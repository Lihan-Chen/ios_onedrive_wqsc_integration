//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

import UIKit
import MSAL

/// 😃 A View Controller that will respond to the events of the Storyboard.

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {
    
    // Mark - Application Constants
    // Update the below to your client ID you received in the portal. The below is for running the demo only
    let kClientID = "6e7a98a3-b668-475e-bfc3-3ae85dd619ef"
    
    // kClientSecret is not used in mobile apps
    // let kClientSecret = "itwsFU2999:(uwdTNWGG8%|"
    
    // Additional variables for Auth and Graph API
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    
    // Team group for WQSC edbc7e15-44cf-4e1e-bf85-a34e9d794e5e
    let kGroupName_WQSC = "WQSC"
    let kGroupId_WQSC = "edbc7e15-44cf-4e1e-bf85-a34e9d794e5e"
    
    // groups.append [kGroupName_WQSC] = kGroupId_WQSC
    
    // WQSC Team Drive ID
    let kTeamDriveId_WQSC  = "drives/01BCC7HDF6Y2GOVW7725BZO354PWSELRRZ/root/children"

    // Dictionary for groups to be used in the future
    var groups = ["WQSC": "edbc7e15-44cf-4e1e-bf85-a34e9d794e5e"]
    
    // Predefined file and url
    
//    let kUrl_Prefix = "https://graph.microsoft.com/v1.0/groups/"
//    let kUrl_Predicate = "?select=name,id,@microsoft.graph.downloadUrl"

    // url for LoadSamples.csv
    // "https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root:/LoadSamples.csv"
//    let kLoadSamplesFileName = "LoadSamples.csv"
    
    // url to get a list of objects in the team drive InBox
    // https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root/children/inbox
    // let kInBoxUrl_WQSC = "\(kUrlString_Prefix)\(kGroupId_WQSC)/drive/root/children/inbox"
    
    // default to LoadSamples
//    lazy var endPointUrl = "\(kUrl_Prefix)\(kGroupId_WQSC)/drive/root:/\(kLoadSamplesFileName)"
//
    var downloadUrl: URL!
    
    // let kInBoxEndPoint = "https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root/children/InBox"
    // Sample format for downloadUrl
    // let kUrlLoadSamples = "https://mwdsocal.sharepoint.com/teams/WQSC/_layouts/15/download.aspx?UniqueId=7de29098-69b5-413a-9bef-0db06ea8254c&Translate=false"

    
    let kScopes: [String] = ["https://graph.microsoft.com/user.read",
                             "https://graph.microsoft.com/Mail.ReadWrite",
                             "https://graph.microsoft.com/Mail.Send",
                             "https://graph.microsoft.com/Files.ReadWrite",
                             "https://graph.microsoft.com/User.ReadBasic.All"]
    
    let kAuthority = "https://login.microsoftonline.com/common"
    
    var accessToken = String()
    var applicationContext : MSALPublicClientApplication?
    var webViewParamaters : MSALWebviewParameters?

    var loggingText: UITextView!
    var signOutButton: UIButton!
    var callGraphButton: UIButton!

    /**
        Setup public client application in viewDidLoad
    */

    override func viewDidLoad() {

        super.viewDidLoad()

        initUI()
        
        do {
            try self.initMSAL()
        } catch let error {
            self.updateLogging(text: "Unable to create Application Context \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.updateSignOutButton(enabled: !self.accessToken.isEmpty)
    }
}

// MARK: Initialization

extension ViewController {
    
    /**
     
     Initialize a MSALPublicClientApplication with a given clientID and authority
     
     - clientId:            The clientID of your application, you should get this from the app portal.
     - redirectUri:         A redirect URI of your application, you should get this from the app portal.
     If nil, MSAL will create one by default. i.e./ msauth.<bundleID>://auth
     - authority:           A URL indicating a directory that MSAL can use to obtain tokens. In Azure AD
     it is of the form https://<instance/<tenant>, where <instance> is the
     directory host (e.g. https://login.microsoftonline.com) and <tenant> is a
     identifier within the directory itself (e.g. a domain associated to the
     tenant, such as contoso.onmicrosoft.com, or the GUID representing the
     TenantID property of the directory)
     - error                The error that occurred creating the application object, if any, if you're
     not interested in the specific error pass in nil.
     */
    func initMSAL() throws {
        
        guard let authorityURL = URL(string: kAuthority) else {
            self.updateLogging(text: "Unable to create authority URL")
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: nil, authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        
        self.webViewParamaters = MSALWebviewParameters(parentViewController: self)
    }
    
//    func getEndpointUrl(groupName group:String, fileName file:String) -> String {
//        let groupId = groups[group]
//        return "\(kUrl_Prefix)\(String(describing: groupId))/drive/root:/\(file)\(kUrl_Predicate)"
//    }
    
    func downLoad(url downloadUrl: URL, fileName downloadFile: String) -> String {
        let task = URLSession.shared.downloadTask(with: downloadUrl) { (urlresponse, response, error) in
               guard let originalUrl = urlresponse else {return}
               
           let fileManager = FileManager.default
               do {
                   // get path to direcgtory
                   let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   
                   // give name to file
                   let newUrl = path.appendingPathComponent(downloadFile)
                   assert(true, downloadFile)
                   if fileManager.fileExists(atPath: downloadFile) {
                       do {
                           try fileManager.removeItem(atPath: downloadFile)
                       } catch let error {
                           print("error occurred. \(error)")
                       }
                   }
                   // move file from original to new
                   try FileManager.default.moveItem(at: originalUrl, to: newUrl)
                   print("\(downloadFile) is downloaded with success!")
               } catch { print(error.localizedDescription); return}
           }
           
           task.resume()
           
           return("\(downloadFile) is successfully loaded!")
       }
    
    func initWebViewParams() {
        self.webViewParamaters = MSALWebviewParameters(parentViewController: self)
    }
}

// MARK: Acquiring and using token

extension ViewController {
    /**
     This will invoke the authorization flow.
     */
    
    @objc func callGraphAPI(_ sender: UIButton) {

        
        guard let currentAccount = self.currentAccount() else {
            // We check to see if we have a current logged in account.
            // If we don't, then we need to sign someone in.
            acquireTokenInteractively()
            return
        }
        
        acquireTokenSilently(currentAccount)
    }
    
    func acquireTokenInteractively() {
        
        guard let applicationContext = self.applicationContext else { return }
        guard let webViewParameters = self.webViewParamaters else { return }

        let parameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount;
        
        applicationContext.acquireToken(with: parameters) { (result, error) in
            
            if let error = error {
                
                self.updateLogging(text: "Could not acquire token: \(error)")
                return
            }
            
            guard let result = result else {
                
                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }
            
            self.accessToken = result.accessToken
            self.updateLogging(text: "Access token is \(self.accessToken)")
            self.updateSignOutButton(enabled: true)
//            self.getContentWithToken()
            self.getDownloadStringWithToken()
        }
    }
    
    func acquireTokenSilently(_ account : MSALAccount!) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        /**
         
         Acquire a token for an existing account silently
         
         - forScopes:           Permissions you want included in the access token received
         in the result in the completionBlock. Not all scopes are
         guaranteed to be included in the access token returned.
         - account:             An account object that we retrieved from the application object before that the
         authentication flow will be locked down to.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         */
        
        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)
        
        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
            
            if let error = error {
                
                let nsError = error as NSError
                
                // interactionRequired means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.
                
                if (nsError.domain == MSALErrorDomain) {
                    
                    if (nsError.code == MSALError.interactionRequired.rawValue) {
                        
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                
                self.updateLogging(text: "Could not acquire token silently: \(error)")
                return
            }
            
            guard let result = result else {
                
                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }
            
            self.accessToken = result.accessToken
            self.updateLogging(text: "Refreshed Access token is \(self.accessToken)")
            self.updateSignOutButton(enabled: true)
//            self.getContentWithToken()
            self.getDownloadStringWithToken()
//            self.downLoad(url: self.downloadUrl, fileName: fileName)
        }
    }
    
    /**
     This will invoke the call to the Microsoft Graph API. It uses the
     built in URLSession to create a connection.
     */
    
    func getContentWithToken() {
        
        // Specify the Graph API endpoint  // kGraphURI

        let url = URL(string: "https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root:/LoadSamples.csv?select=@microsoft.graph.downloadUrl")
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                self.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                
                self.updateLogging(text: "Couldn't deserialize result JSON")
                return
            }

             self.updateLogging(text: "\(result)")
            
            }.resume()
        }
    
    func getDownloadStringWithToken() {
    
        // Specify the file endpoint with predicate
//        let downloadUrlRequest = UrlRequest(fileName: fileName)
//        let url = downloadUrlRequest.resourceUrl
        let url = URL(string: "https://graph.microsoft.com/v1.0/groups/edbc7e15-44cf-4e1e-bf85-a34e9d794e5e/drive/root:/LoadSamples.csv?select=@microsoft.graph.downloadUrl")
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                self.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {
                
                self.updateLogging(text: "Couldn't deserialize result JSON")
                return
            }
            
            guard let downloadUrlString = result["@microsoft.graph.downloadUrl"] as? String else {
                
                self.updateLogging(text: "Couldn't get download url")
                    return
                }
            
            self.downloadUrl = URL(string: downloadUrlString)!
            self.updateLogging(text: "\(downloadUrlString)")
            
            }.resume()
    }
        
    func getdownloadUrlWithToken(fileName:String) -> String {
        var urlString:String = ""
        let endPoint = UrlRequest(fileName: fileName)
        let url = endPoint.resourceUrl
        var request = URLRequest(url: url)
        
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        endPoint.getDownloadUrl{result in
                switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let fileInfo):
                        urlString = fileInfo.downloadUrl
                }
            }
        return urlString
        }
}

// MARK: Get account and removing cache
extension ViewController {
    func currentAccount() -> MSALAccount? {
        
        guard let applicationContext = self.applicationContext else { return nil }
        
        // We retrieve our current account by getting the first account from cache
        // In multi-account applications, account should be retrieved by home account identifier or username instead
        
        do {
            
            let cachedAccounts = try applicationContext.allAccounts()
            
            if !cachedAccounts.isEmpty {
                return cachedAccounts.first
            }
            
        } catch let error as NSError {
            
            self.updateLogging(text: "Didn't find any accounts in cache: \(error)")
        }
        
        return nil
    }
    
    /**
     This action will invoke the remove account APIs to clear the token cache
     to sign out a user from this application.
     */
    @objc func signOut(_ sender: UIButton) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        guard let account = self.currentAccount() else { return }
        
        do {
            
            /**
             Removes all tokens from the cache for this application for the provided account
             
             - account:    The account to remove from the cache
             */
            
            try applicationContext.remove(account)
            self.updateLogging(text: "")
            self.updateSignOutButton(enabled: false)
            self.accessToken = ""
            
        } catch let error as NSError {
            
            self.updateLogging(text: "Received error signing account out: \(error)")
        }
    }
}

// MARK: UI Helpers
extension ViewController {
    
    func initUI() {
        // Add call Graph button
        callGraphButton  = UIButton()
        callGraphButton.translatesAutoresizingMaskIntoConstraints = false
        callGraphButton.setTitle("Call Microsoft Graph API", for: .normal)
        callGraphButton.setTitleColor(.blue, for: .normal)
        callGraphButton.addTarget(self, action: #selector(callGraphAPI(_:)), for: .touchUpInside)
        self.view.addSubview(callGraphButton)
        
        callGraphButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callGraphButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0).isActive = true
        callGraphButton.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        callGraphButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // Add sign out button
        signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.blue, for: .normal)
        signOutButton.setTitleColor(.gray, for: .disabled)
        signOutButton.addTarget(self, action: #selector(signOut(_:)), for: .touchUpInside)
        self.view.addSubview(signOutButton)
        
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.topAnchor.constraint(equalTo: callGraphButton.bottomAnchor, constant: 10.0).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // Add logging textfield
        loggingText = UITextView()
        loggingText.isUserInteractionEnabled = false
        loggingText.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(loggingText)
        
        loggingText.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 10.0).isActive = true
        loggingText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
        loggingText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10.0).isActive = true
        loggingText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10.0).isActive = true
    }
    
    func updateLogging(text : String) {
        
        if Thread.isMainThread {
            self.loggingText.text = text
        } else {
            DispatchQueue.main.async {
                self.loggingText.text = text
            }
        }
    }
    
    func updateSignOutButton(enabled : Bool) {
        if Thread.isMainThread {
            self.signOutButton.isEnabled = enabled
        } else {
            DispatchQueue.main.async {
                self.signOutButton.isEnabled = enabled
            }
        }
    }
}
