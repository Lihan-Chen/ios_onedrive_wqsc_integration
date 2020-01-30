//
//  FileInfoRequest.swift
//  MSALiOS
//
//  Created by Lihan Chen on 1/28/20.
//  Copyright © 2020 Microsoft. All rights reserved.
//

import Foundation

/* GET 1.0 https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root:/LoadSamples.csv?select=name,id,@microsoft.graph.downloadUrl
 */


enum FileError: Error {
    case noDataAvailable
    case cannotProcessData
}

var listOfDownloadUrl = [URL] ()

struct FilesRequest: Codable {
    let resourceURL:URL
    let API_KEY = "abc"
    let TOKEN = "testToken"
    
    init(){
        //for endPoint in endPoints {
        guard let resourceURL = URL( string: "https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root:/LoadSamples.csv?select=name,id,@microsoft.graph.downloadUrl") else {fatalError()}
        self.resourceURL = resourceURL
//            self.listofResourceURL.append(resourceURL)
        //}
    }
    
    func getDownloadUrls(completion: @escaping(Result<FileInfo, FileError>) -> Void) {
        guard let resourceURL = URL( string: "https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root:/LoadSamples.csv?select=name,id,@microsoft.graph.downloadUrl") else {fatalError()}
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let filesResponse = try decoder.decode(FileResponse.self, from: jsonData)
                
//                for fileInfo in filesResponse {
//                var downloadUrl = URL(fileReferenceLiteralResourceName: filesResponse.response.atMicrosoftGraphDownloadUrl)
//                    listOfDownloadUrl.append(contentsOf: downloadUrl)
//                }
                let fileInfo = filesResponse.response
                completion(.success(fileInfo))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
