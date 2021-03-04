//
//  CloudManager.swift
//  CloudNotes
//
//  Created by 리나 on 2021/03/03.
//

import SwiftyDropbox

struct CloudManager {
    static let coreDataFile = "/CloudNotes.sqlite-wal"
    static var client: DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }
    
    static private func authorizeDropbox(viewController: UIViewController) {
        if DropboxClientsManager.authorizedClient == nil && DropboxClientsManager.authorizedTeamClient == nil {
            let scopeRequest = ScopeRequest(scopeType: .user, scopes: CloudString.requiredScope, includeGrantedScopes: false)
            DropboxClientsManager.authorizeFromControllerV2(UIApplication.shared, controller: viewController, loadingStatusDelegate: nil, openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) }, scopeRequest: scopeRequest)
        }
    }
    
    static func download(_ viewController: UIViewController) {
        authorizeDropbox(viewController: viewController)
        let directoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let destinationURL = directoryURL.appendingPathComponent(coreDataFile)
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destinationURL
        }
        
        client?.files.download(path: coreDataFile, overwrite: true, destination: destination).response { response, error in
            if let error = error {
                debugPrint(error)
            }
            if let response = response {
                debugPrint(response)
            }
        }
    }
    
    static func upload(_ viewController: UIViewController) {
        authorizeDropbox(viewController: viewController)
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent(coreDataFile)
        
        client?.files.upload(path: coreDataFile, mode: .overwrite, autorename: false, clientModified: nil, mute: true, input: documentsDirectory).response { response, error in
            if let error = error {
                debugPrint(error)
            }
            if let response = response {
                debugPrint(response)
            }
        }
    }
}
