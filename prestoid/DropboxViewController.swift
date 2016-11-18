//
//  DropboxViewController.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/18/16.
//  Copyright © 2016 Alexander Iashchuk. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyDropbox

class DropboxViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let client = DropboxClientsManager.authorizedClient {
//            client.files.createFolder(path: "/test/path/in/Dropbox/account").response { response, error in
//                if let response = response {
//                    print(response)
//                } else if let error = error {
//                    print(error)
//                }
//            }
//        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func setUpDropbox(_ sender: Any) {
        linkDropboxViaApp()
//        linkDropboxViaBrowser()
    }
    @IBAction func testButtonOne(_ sender: Any) {
        rpcStyleRequest()
    }
    @IBAction func testButtonTwo(_ sender: Any) {
        uploadStyleRequest()
    }
    @IBAction func testButtonThree(_ sender: Any) {
        downloadStyleRequest()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Mark: Dropbox integration
    
    func linkDropboxViaApp() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
//                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                        if #available(iOS 10.0, *) {
                                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                        } else {
                                                            UIApplication.shared.openURL(url)
                                                        }
        })
    }
    
    func linkDropboxViaBrowser() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: {(url: URL) -> Void in
            if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
            }
        }, browserAuth: true)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        return true
    }
    
    // Mark: RPC-style request
    
    func rpcStyleRequest() {
        if let client = DropboxClientsManager.authorizedClient {
        client.files.createFolder(path: "/videos").response { response, error in
            if let response = response {
                print(response)
            } else if let error = error {
                print(error)
            }
        }
        }
    }
    
    // Mark: Upload-style request
    
    func uploadStyleRequest() {
        if let client = DropboxClientsManager.authorizedClient {
        let fileData = "testing data example".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        let request = client.files.upload(path: "/videos/file.txt", input: fileData)
            .response { response, error in
                if let response = response {
                    print(response)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        
        // in case you want to cancel the request
//        if someConditionIsSatisfied {
//            request.cancel()
//        }
        }
    }
    
    // Mark: Download-style request
    
    func downloadStyleRequest() {
        
        // Download to URL
//        let fileManager = FileManager.default
//        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let destURL = directoryURL.appendingPathComponent("file.txt")
//        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
//            return destURL
//        }
//        
//        if let client = DropboxClientsManager.authorizedClient {
//        client.files.download(path: "/videos/file.txt", overwrite: true, destination: destination)
//            .response { response, error in
//                if let response = response {
//                    print(response)
//                } else if let error = error {
//                    print(error)
//                }
//            }
//            .progress { progressData in
//                print(progressData)
//        }
//        }
        
        
        // Download to Data
        
        if let client = DropboxClientsManager.authorizedClient {
        client.files.download(path: "/videos/file")
            .response { response, error in
                if let response = response {
                    let responseMetadata = response.0
                    print(responseMetadata)
                    let fileContents = response.1
                    print(fileContents)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        }
    }
}
