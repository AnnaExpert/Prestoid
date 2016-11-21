//
//  AppDelegate.swift
//  prestoid
//
//  Created by Alexander Iashchuk on 11/2/16.
//  Copyright © 2016 Alexander Iashchuk. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DropboxClientsManager.setupWithAppKey("ioz8ygaeh7x3mfb")
//        DropboxClientsManager.setupWithAppKey("8ijtllupubn89oi")
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: self.window?.rootViewController) {
            if (rootViewController.responds(to: Selector(("canRotate")))) {
                // Unlock landscape view orientations for this view controller
                return .all
            }
        }
        // Only allow portrait (standard behaviour)
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
