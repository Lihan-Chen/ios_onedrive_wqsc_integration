//
//  OneDriveFileLink.swift
//  MSALiOS
//
//  Created by Lihan Chen on 1/22/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation
/** Structure of a OneDrive File Link: **/
/**------------------------------------**/
//{
//    "id": "123ABC",
//    "roles": ["write"],
//    "link": {
//        "type": "view",
//        "scope": "anonymous",
//        "webUrl": "https://1drv.ms/A6913278E564460AA616C71B28AD6EB6",
//        "application": {
//            "id": "1234",
//            "displayName": "Sample Application"
//        },
//    }
//}

struct OneDriveFileLink {
    let id: String
    let roles: [String]
    let link: [String: Any]
    let webUrl: String
}

extension OneDriveFileLink {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
              let link = json["link"] as? [String: Any],
              let roles = json["roles"] as? [String],
              let webUrl = link["webUrl"] as? String else {
            return nil
        }

        self.id = id
        self.roles = roles
        self.link = link
        self.webUrl = webUrl
    }
}
