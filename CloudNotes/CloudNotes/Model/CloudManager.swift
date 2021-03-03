//
//  CloudManager.swift
//  CloudNotes
//
//  Created by 리나 on 2021/03/03.
//

import SwiftyDropbox

struct CloudManager {
    static let coreDataFile = "/CloudNotes.sqlite-wal"
    static let client = DropboxClientsManager.authorizedClient
    
    enum PermissionType  {
        case upload, download
    }
    
    static private func authorizeDropbox(for permissionType: PermissionType, viewController: UIViewController) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["\(permissionType)"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(UIApplication.shared, controller: viewController, loadingStatusDelegate: nil, openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) }, scopeRequest: scopeRequest)
    }
    
    static func download(_ viewController: UIViewController) {
        authorizeDropbox(for: .download, viewController: viewController)
        
        let directoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let destinationURL = directoryURL.appendingPathComponent(coreDataFile)
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destinationURL
        }
        
        client?.files.download(path: coreDataFile, overwrite: true, destination: destination).response { response, error in
           if let error = error {
                print(error)
            }
        }
        .progress { progressData in
            print(progressData)
        }
    }
    
    static func upload(_ viewController: UIViewController) {
        authorizeDropbox(for: .download, viewController: viewController)

        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent(coreDataFile)
        
        client?.files.upload(path: coreDataFile, mode: .overwrite, autorename: false, clientModified: nil, mute: true, input: documentsDirectory).response { response, error in
            if let error = error {
                print(error)
            }
        }
        .progress { progressData in
            print(progressData)
        }
    }
}

extension CloudManager.PermissionType: CustomStringConvertible {
    var description: String {
        switch self {
        case .upload:
            return "files.content.write"
        case .download:
            return "files.content.read"
        }
    }
}
