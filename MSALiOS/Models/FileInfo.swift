//
//  FileInfo.swift
//  MSALiOS
//
//  Created by Lihan Chen on 1/26/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

struct FileInfo: Codable {
    
    var id: String
    var name: String
    var downloadUrl: String
    var eTag: String
    var cTag: String
    
}
