//
//  CloudManager.swift
//  CloudNotes
//
//  Created by 리나 on 2021/03/03.
//

import SwiftyDropbox

struct CloudManager {
    static let coreDataFile = "/CloudNotes.sqlite-wal"
    static let coreDataFile2 = "/CloudNotes.sqlite-shm"
    static let coreDataFile3 = "/CloudNotes.sqlite"
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
        let fileNames = [coreDataFile, coreDataFile2, coreDataFile3]
        for file in fileNames {
            let destinationURL = directoryURL.appendingPathComponent(file)
            let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                return destinationURL
            }
            client?.files.download(path: file, overwrite: true, destination: destination).response { response, error in
                if let error = error {
                    debugPrint(error)
                }
                if let response = response {
                    DataModel.shared.fetchData()
                    NotificationCenter.default.post(name: NSNotification.Name(NoteString.notification), object: nil)
                    debugPrint(response)
                }
            }
        }
    }
    
    static func upload(_ viewController: UIViewController) {
        authorizeDropbox(viewController: viewController)
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let fileNames = [coreDataFile, coreDataFile2, coreDataFile3]
        for file in fileNames {
            let documentsDirectory = paths[0].appendingPathComponent(file)
            
            client?.files.upload(path: file, mode: .overwrite, autorename: false, clientModified: nil, mute: true, input: documentsDirectory).response { response, error in
                if let error = error {
                    debugPrint(error)
                }
                if let response = response {
                    debugPrint(response)
                }
            }
        }
    }
}
