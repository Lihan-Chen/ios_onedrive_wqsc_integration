//
//  FileInfo.swift
//  MSALiOS
//
//  Created by Lihan Chen on 1/26/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

struct FileResponse:Codable {
    var response: FileInfo
}

struct FileInfo: Codable {
    
    var atOdataContent:String
    var atMicrosoftGraphDownloadUrl:String
//    var createdDateTime:String
//    var eTag:String
    var id:String
//    var lastModifiedDateTime:String
    var name:String
//    var webUrl:String
//    var cTag:String
    var size:Int
//    var createdBy:User
//    var lastModifiedBy: User
//    var parentReference:ParentReference 
//    var file:File
//    var fileSystemInfo:FileSystemInfo
    
//    // User
//    struct User:Codable {
//        var email:String
//        var id:String
//        var displayName:String
//    }
//
//    struct ParentReference:Codable {
//        var drvieId:String
//        var driveType:String
//        var id:String
//        var path:String
//    }
//
//    struct File: Codable {
//        var mimeType:String
//        var hashes:QuickHash
//    }
//
//    struct QuickHash:Codable {
//        var hashValue:String
//    }
//
//    struct FileSystemInfo:Codable {
//        var createdDateTime:String
//        var lastModifiedDateTime:String
//    }
    
    

    
    // Data Example
    // "@odata.context"
    let context = "https://graph.microsoft.com/v1.0/$metadata#groups('edbc7e15-44cf-4e1e-bf85-a34e9d794e5e')/drive/root/$entity"
    // "@microsoft.graph.downloadUrl"
    var downloadUrl: String
    var uniqueId:String // =7de29098-69b5-413a-9bef-0db06ea8254c
    let rootUrl = "https://mwdsocal.sharepoint.com/teams/WQSC/_layouts/15/download.aspx"
    let translate = false
    var tempauth:String // token
    
}

//{
//    "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#groups('edbc7e15-44cf-4e1e-bf85-a34e9d794e5e')/drive/root/$entity",
//    "@microsoft.graph.downloadUrl": "https://mwdsocal.sharepoint.com/teams/WQSC/_layouts/15/download.aspx?UniqueId=7de29098-69b5-413a-9bef-0db06ea8254c&Translate=false&tempauth=eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTBmZjEtY2UwMC0wMDAwMDAwMDAwMDAvbXdkc29jYWwuc2hhcmVwb2ludC5jb21AMmZiMDE5YmMtZTAzNS00MTk2LTk1NjMtZjFhMWE0MDBjODIwIiwiaXNzIjoiMDAwMDAwMDMtMDAwMC0wZmYxLWNlMDAtMDAwMDAwMDAwMDAwIiwibmJmIjoiMTU4MDE0MjgxMSIsImV4cCI6IjE1ODAxNDY0MTEiLCJlbmRwb2ludHVybCI6IkJ0ck4rbWhZVTJXdks3U2UyeW4vRk9iTGQ5dE92cE9YcWY3TlNDWDlVa0E9IiwiZW5kcG9pbnR1cmxMZW5ndGgiOiIxMzAiLCJpc2xvb3BiYWNrIjoiVHJ1ZSIsImNpZCI6IlpEZGlOV0V3WWpFdFpUbGxOaTAwTTJabUxUazNOV0l0WmpVMllqUXlOMkl3WkdZeiIsInZlciI6Imhhc2hlZHByb29mdG9rZW4iLCJzaXRlaWQiOiJOMk5oT1RObE9HVXRPV1JoWlMwME9UZGlMVGxrWmpFdE1qazJNek01TURkaU1qY3ciLCJhcHBfZGlzcGxheW5hbWUiOiJHcmFwaCBleHBsb3JlciIsImdpdmVuX25hbWUiOiJMaWhhbiIsImZhbWlseV9uYW1lIjoiQ2hlbiIsInNpZ25pbl9zdGF0ZSI6IltcImttc2lcIl0iLCJhcHBpZCI6ImRlOGJjOGI1LWQ5ZjktNDhiMS1hOGFkLWI3NDhkYTcyNTA2NCIsInRpZCI6IjJmYjAxOWJjLWUwMzUtNDE5Ni05NTYzLWYxYTFhNDAwYzgyMCIsInVwbiI6ImxjaGVuQG13ZGgyby5jb20iLCJwdWlkIjoiMTAwMzdGRkVBMTgxQTE5OSIsImNhY2hla2V5IjoiMGguZnxtZW1iZXJzaGlwfDEwMDM3ZmZlYTE4MWExOTlAbGl2ZS5jb20iLCJzY3AiOiJteWZpbGVzLnJlYWQgYWxsZmlsZXMucmVhZCBteWZpbGVzLndyaXRlIGFsbGZpbGVzLndyaXRlIGFsbHNpdGVzLndyaXRlIGFsbHByb2ZpbGVzLnJlYWQiLCJ0dCI6IjIiLCJ1c2VQZXJzaXN0ZW50Q29va2llIjpudWxsfQ.ZFh4bk1VSmRXS0J6d2RVRGR6RVFnOUxNRXRCMzhUais4clhwQ0IwMlVCND0&ApiVersion=2.0",
//    "createdDateTime": "2019-12-23T22:19:03Z",
//    "eTag": "\"{7DE29098-69B5-413A-9BEF-0DB06EA8254C},2\"",
//    "id": "01BCC7HDEYSDRH3NLJHJAZX3YNWBXKQJKM",
//    "lastModifiedDateTime": "2019-12-23T22:19:03Z",
//    "name": "LoadSamples.csv",
//    "webUrl": "https://mwdsocal.sharepoint.com/teams/WQSC/_layouts/15/Doc.aspx?sourcedoc=%7B7DE29098-69B5-413A-9BEF-0DB06EA8254C%7D&file=LoadSamples.csv&action=default&mobileredirect=true",
//    "cTag": "\"c:{7DE29098-69B5-413A-9BEF-0DB06EA8254C},2\"",
//    "size": 126380,
//    "createdBy": {
//        "user": {
//            "email": "SWalker@mwdh2o.com",
//            "id": "e5ce3c4a-fab2-4b3e-871a-10b5274003d9",
//            "displayName": "Walker,Shawn A"
//        }
//    },
//    "lastModifiedBy": {
//        "user": {
//            "email": "SWalker@mwdh2o.com",
//            "id": "e5ce3c4a-fab2-4b3e-871a-10b5274003d9",
//            "displayName": "Walker,Shawn A"
//        }
//    },
//    "parentReference": {
//        "driveId": "b!jj6pfK6de0md8SljOQeycMkKi3G4OCdDqUh89Sm_1wWrt5Ond2JBTK_-4ub3YJ0-",
//        "driveType": "documentLibrary",
//        "id": "01BCC7HDF6Y2GOVW7725BZO354PWSELRRZ",
//        "path": "/drive/root:"
//    },
//    "file": {
//        "mimeType": "application/vnd.ms-excel",
//        "hashes": {
//            "quickXorHash": "QszJAkOjCrXzCMLvOTz+1v5EFzg="
//        }
//    },
//    "fileSystemInfo": {
//        "createdDateTime": "2019-12-23T22:19:03Z",
//        "lastModifiedDateTime": "2019-12-23T22:19:03Z"
//    }
//}
