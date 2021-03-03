//
//  CloudManager.swift
//  CloudNotes
//
//  Created by 리나 on 2021/03/03.
//

import SwiftyDropbox

struct CloudManager {
    let coreDataFile = "CloudNotes.sqlite-wal"
    let client = DropboxClientsManager.authorizedClient
    
    enum PermissionType  {
        case upload, download
    }
    
    func authorizeDropbox(for permissionType: PermissionType, viewController: UIViewController) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["\(permissionType)"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: viewController,
            loadingStatusDelegate: nil,
            openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
            scopeRequest: scopeRequest
        )
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
