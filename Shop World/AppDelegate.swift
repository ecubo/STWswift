//
//  AppDelegate.swift
//  Tutorial-MapKitSwift
//
//  Created by Cubo, Emilio on 16/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

                
        let navbarFont = UIFont(name: "Bryant-BoldCondensed", size: 19) ?? UIFont.systemFontOfSize(19);
        let barbuttonFont = UIFont(name: "Bryant-BoldCondensed", size: 15) ?? UIFont.systemFontOfSize(15);
        
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.whiteColor()];
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: barbuttonFont, NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal);
        
        // MARK: - Escalar imagen estante
        var myImage = UIImage(named: "toldo");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 64)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UINavigationBar.appearance().setBackgroundImage(newImage, forBarMetrics: .Default);
        UINavigationBar.appearance().shadowImage = UIImage(named: "");
        UINavigationBar.appearance().tintColor = UIColor.whiteColor();

        
        

        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Bryant-BoldCondensed", size: 11) ?? UIFont.systemFontOfSize(11), NSForegroundColorAttributeName: UIColor(white: 255.0, alpha: 0.5)], forState:.Normal);
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected);
        
        
        application.statusBarStyle = .LightContent;
        UIApplication.sharedApplication().statusBarStyle = .LightContent;
        
//        var tabBarController = self.window!.rootViewController as! UITabBarController;
//        var tabBar = tabBarController.tabBar as UITabBar;
//
//        for item in tabBar.items as! [UITabBarItem] {
//            if let image = item.image {
//                //item.image = image.imageWithRenderingMode(.AlwaysOriginal);
//                item.image = image.imageWithColor(UIColor(white: 255.0, alpha: 0.5)).imageWithRenderingMode(.AlwaysOriginal)
//            }
//        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// Add anywhere in your app
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

