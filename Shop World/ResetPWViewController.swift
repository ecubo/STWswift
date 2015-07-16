//
//  ResetPWViewController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 3/7/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class ResetPWViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var persiana: UIImageView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnResetPW: UIButton!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    var respuestaPHP:NSString?;


    override func viewDidLoad() {
        super.viewDidLoad()


        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);

        txtEmail.delegate = self;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        txtEmail.resignFirstResponder();
        btnResetPW.sendActionsForControlEvents(UIControlEvents.TouchUpInside);
        return true;
    }

    
    @IBAction func requestPW(sender: UIButton) {
        
        let email = txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        if (email != "") {
            loading.hidden = false;
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
            let urlPHP = "http://shoptheworld.labstoreshopper.com/api/markers/api_stw.php?p=reset_pw";
            var datosEnvio:NSMutableString = "correo=";
            datosEnvio.appendString(txtEmail.text);
            var request = NSMutableURLRequest(URL: NSURL(string: urlPHP)!);
            request.HTTPMethod = "POST";
            
            //5º Ponemos mochila al carterlo
            request.HTTPBody = (datosEnvio as String).dataUsingEncoding(NSUTF8StringEncoding)
            
            //6º Creamos un proceso nuevo, donde a request con el paquete datosEnvio envie los datos al webservice
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

        } else {
            UIAlertView(title: NSLocalizedString("Incomplete Data", comment: "Incomplete Data"), message: NSLocalizedString("Fill out all fields , please", comment: "Fill out all fields , please"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        }
        

    }
    
    func comprobarRespuesta(){
        loading.hidden = true;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;

        if (respuestaPHP == "ok"){
            UIAlertView(title: NSLocalizedString("Password Reset", comment: "Password Reset"), message: NSLocalizedString("You will receive an email with your new password", comment: "You will receive an email with your new password"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
            
            let signIn = self.storyboard?.instantiateViewControllerWithIdentifier("signIn") as! InicioViewController;
            signIn.navigationItem.setHidesBackButton(true, animated:false);
            self.navigationController?.pushViewController(signIn, animated: true);
        }
        else {
            UIAlertView(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("There is no registered user with this e-mail", comment: "There is no registered user with this e-mail"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
            txtEmail.text = "";
            txtEmail.becomeFirstResponder();
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
