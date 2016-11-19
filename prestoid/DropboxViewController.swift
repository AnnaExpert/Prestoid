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

public class DropboxViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var videosArray: [String] = Array()
    let savedVideosArrayKey = "savedVideosArray"
    let user = DropboxUser()
    
    @IBOutlet weak var dropboxLogoImageView: UIImageView!
    @IBOutlet weak var authorizeYourAccountTextLabel: UILabel!
    @IBOutlet weak var connectDropboxAccountButton: UIButton!
    
    @IBOutlet weak var disconnectDropboxAccountButton: UIButton!
    @IBOutlet weak var dropboxAccountAuthorizedLabel: UILabel!
    @IBOutlet weak var accountPhotoImageView: UIImageView!
    @IBOutlet weak var userNameTextLabel: UILabel!
    @IBOutlet weak var userEmailTextLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    public class DropboxUser {
        var authorized = false
        var name = "Dropbox User"
        var email = "email@dropbox.com"
        var avatar = UIImage(named: "Dropbox")!
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        if let user = DropboxClientsManager.authorizedClient {
//            checkAllFiles()
//        }
        
        
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
    @IBAction func testButton(_ sender: Any) {
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let arrayValue = defaults.array(forKey: savedVideosArrayKey) {
            videosArray = arrayValue as! [String]
        }
        user.authorized = checkAuthorization()
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func connectDropboxAccount(_ sender: Any) {
        // Link account via iOS application
        linkDropboxViaApp()
    }
    
    @IBAction func disconnectDropboxAccount(_ sender: Any) {
        DropboxClientsManager.unlinkClients()
        loadingActivityIndicator.stopAnimating()
        accountPhotoImageView.isHidden = true
        userNameTextLabel.isHidden = true
        userEmailTextLabel.isHidden = true
        disconnectDropboxAccountButton.isHidden = true
        dropboxAccountAuthorizedLabel.isHidden = true
        dropboxLogoImageView.isHidden = false
        authorizeYourAccountTextLabel.isHidden = false
        connectDropboxAccountButton.isHidden = false
        let user = DropboxUser()
        user.authorized = false
    }
    
    // Mark: Dropbox integration
    
    func checkAuthorization() -> Bool {
        if DropboxClientsManager.authorizedClient != nil {
            loadingActivityIndicator.isHidden = false
            loadingActivityIndicator.startAnimating()
            dropboxLogoImageView.isHidden = true
            authorizeYourAccountTextLabel.isHidden = true
            connectDropboxAccountButton.isHidden = true
            
            _ = DropboxClientsManager.authorizedClient!.users.getCurrentAccount()
                .response { response, error in
                    if let response = response {
                        let user = DropboxUser()
                        user.email = response.email
                        user.name = response.name.displayName
                        if let userImageUrl = response.profilePhotoUrl {
                            if let url = URL(string: userImageUrl) {
                                if let data = NSData(contentsOf: url) {
                                    user.avatar = UIImage(data: data as Data)!
                                }
                            }
                        } else {
                            user.avatar = UIImage(named: "Dropbox")!
                        }
                        self.accountPhotoImageView.layer.cornerRadius = self.accountPhotoImageView.frame.width/4.0
                        self.accountPhotoImageView.clipsToBounds = true
                        self.accountPhotoImageView.image = user.avatar
                        self.userNameTextLabel.text = user.name
                        self.userEmailTextLabel.text = user.email
                        self.accountPhotoImageView.isHidden = false
                        self.userNameTextLabel.isHidden = false
                        self.userEmailTextLabel.isHidden = false
                        self.disconnectDropboxAccountButton.isHidden = false
                        self.dropboxAccountAuthorizedLabel.isHidden = false
                        self.loadingActivityIndicator.stopAnimating()
                    } else if let error = error {
                        print(error)
                    }
            }
            return true
        } else {
            loadingActivityIndicator.stopAnimating()
            accountPhotoImageView.isHidden = true
            userNameTextLabel.isHidden = true
            userEmailTextLabel.isHidden = true
            disconnectDropboxAccountButton.isHidden = true
            dropboxAccountAuthorizedLabel.isHidden = true
            
            dropboxLogoImageView.isHidden = false
            authorizeYourAccountTextLabel.isHidden = false
            connectDropboxAccountButton.isHidden = false
            return false
        }
    }
    
    func linkDropboxViaApp(completion: ((Bool) -> Swift.Void)? = nil) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        if #available(iOS 10.0, *) {
                                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                        } else {
                                                            UIApplication.shared.openURL(url)
                                                        }
        })
    }
    
    func linkDropboxViaBrowser() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: {(url: URL) -> Void in
                                                        if #available(iOS 10.0, *) {
                                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                        } else {
                                                            UIApplication.shared.openURL(url)
                                                        }
        }, browserAuth: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Mark: RPC-style request
    
    func checkAllFiles() {
        if let client = DropboxClientsManager.authorizedClient {
            
        }
    }
    
    func rpcStyleRequest() {
        if let client = DropboxClientsManager.authorizedClient {
        client.files.createFolder(path: "/")
            .response { response, error in
            if let response = response {
                print(response)
            } else if let error = error {
                print(error)
            }
        }
        }
    }
    
    // Mark: Upload-style request
    
    public func uploadLastVideoFile() {
        let defaults = UserDefaults.standard
        if let arrayValue = defaults.array(forKey: savedVideosArrayKey) {
            videosArray = arrayValue as! [String]
        }
        if let client = DropboxClientsManager.authorizedClient {
            let path = videosArray.last!
            let docsPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            let videoFileDataPath = docsPath + "/" + path + ".mov"
            let videoFileURL = URL.init(fileURLWithPath: videoFileDataPath)
            do {
                let videoFileData = try Data(contentsOf: videoFileURL)
                let fileData = videoFileData
                let request = client.files.upload(path: "/\(path).mov", input: fileData)
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
            } catch {
                print("Can't load data file fro iPhone memory")
            }
            
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
        client.files.download(path: "/file")
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
