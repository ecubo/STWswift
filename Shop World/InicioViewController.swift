//
//  InicioViewController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 30/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var persiana: UIImageView!
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPW: UITextField!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var signInButton: UIButton!
    
    var respuestaPHP:NSString?;
    var user:String?;
    var pw:String?;

    override func viewDidLoad() {
        super.viewDidLoad()

        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);

        txtUser.delegate = self;
        txtPW.delegate = self;
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        switch textField.restorationIdentifier! {
        case "userReg":
            txtPW.becomeFirstResponder();
            break;
        case "pwReg":
            textField.resignFirstResponder();
            signInButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside);
            break;
        default:
            return false;
        }
        return false;
    }

    
    @IBAction func signIn(sender: UIButton) {
        user = txtUser.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        pw = txtPW.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        
        if (user == "" && pw == "") {
            UIAlertView(title: NSLocalizedString("Incomplete Data", comment: "Incomplete Data"), message: NSLocalizedString("Fill out all fields , please", comment: "Fill out all fields , please"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        } else {
            loading.hidden = false;
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true;

            let urlPHP = "http://shoptheworld.labstoreshopper.com/api/markers/api_stw.php?p=comprobar";
            
            var datosEnvio:NSMutableString = "usuario=";
            datosEnvio.appendString(user!);
            datosEnvio.appendString("&password=");
            datosEnvio.appendString(pw!);
            
            var request = NSMutableURLRequest(URL: NSURL(string: urlPHP)!);
            request.HTTPMethod = "POST";
            
            request.HTTPBody = (datosEnvio as String).dataUsingEncoding(NSUTF8StringEncoding)
            
            let proceso: Void = NSURLSession.sharedSession().dataTaskWithRequest(request,
                completionHandler:{(data:NSData!,response:NSURLResponse!,error:NSError!) in
                    if error != nil {
                        UIAlertView(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Failed to connect to server. Try again.", comment: "Failed to connect to server. Try again."), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
                    } else {
                        self.respuestaPHP = NSString(data: data, encoding: NSUTF8StringEncoding);
                        dispatch_async(dispatch_get_main_queue(), {
                            self.comprobarRespuesta();
                        });
                    }
                }
                ).resume();
        }
    }

    func comprobarRespuesta(){
        
        loading.hidden = true;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        
        if (self.respuestaPHP == "error") {
            UIAlertView(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Username or password are incorrect.", comment: "Username or password are incorrect."), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        } else {
            txtUser.text = "";
            txtPW.text = "";
            let inicio = self.storyboard?.instantiateViewControllerWithIdentifier("inicio") as! TabBarController;
            let localStorage = NSUserDefaults.standardUserDefaults();
            localStorage.setObject(respuestaPHP, forKey: "id_usuario");
            self.presentViewController(inicio, animated: true, completion: nil);
        }
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
