//
//  DetailViewController.swift
//  Tutorial-MapKitSwift
//
//  Created by Cubo, Emilio on 17/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var annotation:CustomPointAnnotation?;
    var annotation2:Annotation?;
    var baseURLImages:String = "http://shoptheworld.labstoreshopper.com/api/markers/uploads/";


    @IBOutlet var imgLanding: UIImageView!
    @IBOutlet var txtTitle: UILabel!
    @IBOutlet var txtAdress: UILabel!
    @IBOutlet var persiana: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);
        
    }

    override func viewWillAppear(animated: Bool) {
        
        if (annotation != nil) {
            //self.title = annotation.title;
            txtTitle.text = annotation!.title;
            txtAdress.text = annotation!.direccion;
            
            let urlString:String = "\(baseURLImages)\(annotation!.bkImage).jpg";
            let urlImage:NSURL = NSURL(string: urlString)!;
            let urlData:NSData = NSData(contentsOfURL: urlImage)!;

            let request: NSURLRequest = NSURLRequest(URL: urlImage)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imgLanding.image = UIImage(data: urlData);
                    })
                }
            })
        }
        else if (annotation2 != nil) {
            //self.title = annotation.title;
            txtTitle.text = annotation2!.title;
            txtAdress.text = annotation2!.subtitle;

            let urlString:String = "\(baseURLImages)\(annotation2!.image!).jpg";
            let urlImage:NSURL = NSURL(string: urlString)!;
            let urlData:NSData = NSData(contentsOfURL: urlImage)!;
            let request: NSURLRequest = NSURLRequest(URL: urlImage)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imgLanding.image = UIImage(data: urlData);
                    })
                }
            })
        }
        
        let imageRightRouteButton = UIImage(named: "mapa")
        let rightRouteButton = UIBarButtonItem(image: imageRightRouteButton, style: .Plain, target: self, action: "routeMap:")
        rightRouteButton.tintColor = UIColor.whiteColor();
        
        let imageRightCommentButton = UIImage(named: "comment")
        let rightCommentButton = UIBarButtonItem(image: imageRightCommentButton, style: .Plain, target: self, action: "addComment:")
        rightCommentButton.tintColor = UIColor.whiteColor();
        
        self.navigationItem.setRightBarButtonItems([rightRouteButton,rightCommentButton], animated: true);

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func routeMap(sender: UIButton) {
        if (annotation != nil) {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?daddr=\(annotation!.coordinate.latitude),\(annotation!.coordinate.longitude)")!);
        } else if (annotation2 != nil) {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?daddr=\(annotation2!.coordinates!.latitude),\(annotation2!.coordinates!.longitude)")!);
        }
    }
    
    func addComment (sender:UIButton) {
        // TODO Funcionalidad Añadir Comentario
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
