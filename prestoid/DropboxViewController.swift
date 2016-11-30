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
    var speechArray: [String] = Array()
    let savedSpeechArrayKey = "savedSpeechArray"
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
    
    @IBOutlet weak var uploadingProgress: UIProgressView!
    @IBOutlet weak var uploadingLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshProgressView: UIProgressView!
    
    public class DropboxUser {
        var authorized = false
        var name = "Dropbox User"
        var email = "email@dropbox.com"
        var avatar = UIImage(named: "Dropbox")!
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func testButton(_ sender: Any) {
        downloadAllFiles()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // Link Dropbox account via iOS application
    
    @IBAction func connectDropboxAccount(_ sender: Any) {
        linkDropboxViaApp()
    }
    
    // Unlink Dropbox account from current session
    
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
    
    // Mark: Download all new files
    
    public func downloadAllFiles() {
        if let client = DropboxClientsManager.authorizedClient {
            client.files.listFolder(path: "/PrestoidMedia")
                .response { response, error in
                    let defaults = UserDefaults.standard
                    if let arrayValue = defaults.array(forKey: self.savedVideosArrayKey) {
                        self.videosArray = arrayValue as! [String]
                    }
                    if let response = response?.entries {
                        for item in response {
                            let dropboxName = item.name
                            let dropboxPath = item.pathDisplay!
                            var localName = ""
                            print(localName)
                            var match = false
                            for name in self.videosArray {
                                let filename = "\(name).mov"
                                localName = name
                                //                                print(filename)
                                //                                print(dropboxName)
                                //                                let isEqual = (filename == dropboxName)
                                //                                print(isEqual)
                                if (filename == dropboxName) {
                                    print("Have this file")
                                    match = true
                                }
                            }
                            if !match {
                                self.downloadFile(fromPath: dropboxPath, localName: dropboxName)
                            }
                        }
                    } else if let error = error {
                        print(error)
                    }
            }
        }
    }
    
    // Mark: Download File to Data
    
    public func downloadFile(fromPath: String, localName: String) {
        var result = NSData()
        let nameArray = String(describing: localName).components(separatedBy: ".")
        let fileName = nameArray[0] + "." + nameArray[1] + "." + nameArray[2]
        if let client = DropboxClientsManager.authorizedClient {
            client.files.download(path: fromPath)
                .response { response, error in
                    if let response = response {
                        let responseMetadata = response.0
                        print(responseMetadata)
                        let fileContents = response.1
                        result = fileContents as NSData
                        //                        print(result)
                        self.saveFile(fileContents: result, localName: fileName)
                        self.refreshProgressView.isHidden = true
                        self.refreshButton.isEnabled = true
                    } else if let error = error {
                        print(error)
                        self.downloadAllFiles()
                        self.refreshProgressView.isHidden = true
                        self.refreshButton.isEnabled = true
                    }
                }
                .progress { progressData in
                    self.refreshProgressView.isHidden = false
                    self.refreshButton.isEnabled = false
                    self.refreshProgressView.progress = Float(progressData.fractionCompleted)
            }
        }
    }
    
    func saveFile(fileContents: NSData, localName: String) {
        let defaults = UserDefaults.standard
        if let arrayValue = defaults.array(forKey: self.savedVideosArrayKey) {
            self.videosArray = arrayValue as! [String]
        }
        print(self.videosArray)
        let docsPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = docsPath + "/" + localName + ".mov"
        print(filePath)
        fileContents.write(toFile: filePath, atomically: false)
        self.videosArray.append(localName)
        defaults.set(self.videosArray, forKey: self.savedVideosArrayKey)
    }
    
    // MARK: Delete files from Dropbox
    
    public func deleteFile(name: String) {
        let videoFilePath = "/PrestoidMedia/" + name + ".mov"
        if let client = DropboxClientsManager.authorizedClient {
            client.files.delete(path: videoFilePath)
        }
        let textFilePath = "/PrestoidMedia/" + name + ".txt"
        if let client = DropboxClientsManager.authorizedClient {
            client.files.delete(path: textFilePath)
        }
    }
    
    // Mark: List folder
    
    public func checkAllFiles() {
        if let client = DropboxClientsManager.authorizedClient {
            client.files.listFolder(path: "")
                .response { response, error in
                    if let result = response?.entries {
                        print(result)
                    } else if let error = error {
                        print(error)
                    }
            }
        }
    }
    
    // Mark: Upload video and text file
    
    public func uploadVideoFile(filePath: String) {
        let defaults = UserDefaults.standard
        if let arrayValue = defaults.array(forKey: savedVideosArrayKey) {
            videosArray = arrayValue as! [String]
        }
        if let arrayValue = defaults.array(forKey: savedSpeechArrayKey) {
            speechArray = arrayValue as! [String]
        }
        if let client = DropboxClientsManager.authorizedClient {
            //            self.rpcStyleRequest()
            let path = filePath
            let docsPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
            let videoFileDataPath = docsPath + "/" + path + ".mov"
            let videoFileURL = URL.init(fileURLWithPath: videoFileDataPath)
            do {
                let videoFileData = try Data(contentsOf: videoFileURL)
                let fileData = videoFileData
                _ = client.files.upload(path: "/PrestoidMedia/\(path).mov", input: fileData)
                    .response { response, error in
                        if let response = response {
                            print(response)
//                            self.uploadingLabel.isHidden = true
//                            self.uploadingProgress.isHidden = true
                        } else if let error = error {
                            self.uploadVideoFile(filePath: filePath)
                            print(error)
                        }
                    }
                    .progress { progressData in
//                        self.uploadingLabel.isHidden = false
//                        self.uploadingProgress.isHidden = false
//                        self.uploadingProgress.progress = Float(progressData.fractionCompleted)
                        print(progressData)
                }
                
                // in case you want to cancel the request
                //        if someConditionIsSatisfied {
                //            request.cancel()
                //        }
            } catch {
                print("Can't load data file from iPhone memory")
            }
        }
    }
    
}
