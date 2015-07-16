//
//  TabBarController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 30/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var tabBar = self.tabBar as UITabBar;
        
        for item in tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                //item.image = image.imageWithRenderingMode(.AlwaysOriginal);
                item.image = image.imageWithColor(UIColor(white: 255.0, alpha: 0.5)).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
