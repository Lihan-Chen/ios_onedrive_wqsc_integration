//
//  RequestUrl.swift
//  MSALiOS
//
//  Created by Lihan Chen on 1/28/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

/* GET 1.0 https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root:/LoadSamples.csv?select=name,id,@microsoft.graph.downloadUrl

    WQSC_GroupId = "edbc7e15-44cf-4e1e-bf85-a34e9d794e5e"
*/
let wQSC_GroupId = "edbc7e15-44cf-4e1e-bf85-a34e9d794e5e"
let rootEndPoint = "https://graph.microsoft.com/v1.0/groups/\(wQSC_GroupId)/drive/root:/"
let loadSamples = "LoadSamples.csv"
let loadSamples_endPoint = "\(rootEndPoint)/\(loadSamples)??select=name,id,@microsoft.graph.downloadUrl"

let endPoints = [loadSamples_endPoint]

struct RequestUrl {
    var method:Method
    var version:String
    var url:String
}

enum Method {
    case GET
    case POST
    case PUT
    case DELETE
}
