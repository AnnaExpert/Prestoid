//
//  AppDelegate.swift
//  Prestoid - Dropbox sync video camera app with speech to text recognition
//  Application version 1.3, build 23, 2017.02.22
//
//  Created by Alexander Iashchuk on 11/2/16.
//  Copyright © 2016 Alexander Iashchuk (iAlexander), http://iashchuk.com
//  Application owner - Scott Leatham. All rights reserved.
//


import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: WARNING: Do not forget to insert the Dropbox application API key here, and in the Info.plist file
        
        DropboxClientsManager.setupWithAppKey("fcknlb5qwqct21g")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success(let token):
                print("Success! User is logged into Dropbox with token: \(token)")
                let user = DropboxViewController.DropboxUser()
                user.authorized = true
                return true
            case .cancel:
                print("User canceld OAuth flow.")
                let user = DropboxViewController.DropboxUser()
                user.authorized = false
                return false
            case .error(let error, let description):
                print("Error \(error): \(description)")
                let user = DropboxViewController.DropboxUser()
                user.authorized = false
                return false
            }
        }
        let user = DropboxViewController.DropboxUser()
        user.authorized = false
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: self.window?.rootViewController) {
            if (rootViewController.responds(to: Selector(("canRotate")))) {
                return .all
            }
        }
        return .portrait;
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
}
