//
//  RegistroViewController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 30/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var persiana: UIImageView!
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPW: UITextField!
    @IBOutlet var txtPW2: UITextField!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var signUpButton: UIButton!
    
    var user:String?;
    var email:String?;
    var pw:String?;
    var pw2:String?;
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

        txtUser.delegate = self;
        txtEmail.delegate = self;
        txtPW.delegate = self;
        txtPW2.delegate = self;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        switch textField.restorationIdentifier! {
        case "user":
            txtEmail.becomeFirstResponder();
            break;
        case "email":
            txtPW.becomeFirstResponder();
            break;
        case "pw":
            txtPW2.becomeFirstResponder();
            break;
        case "pw2":
            textField.resignFirstResponder();
            signUpButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside);
            break;
        default:
            return false;
        }
        return false;
    }

    @IBAction func signUp(sender: UIButton) {

        user = txtUser.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        email = txtEmail.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        pw = txtPW.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        pw2 = txtPW2.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        
        if (user != "" && email != "" && pw != "" && pw2 != "") {
            if (pw != pw2) {
                UIAlertView(title: NSLocalizedString("Password", comment: "Password"), message: NSLocalizedString("The password does not match", comment: "The password does not match"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
            } else if (!isValidEmail(email!)) {
                UIAlertView(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("The email address is invalid", comment: "The email address is invalid"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
            }
            else {
                loading.hidden = false;
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
                let urlPHP = "http://shoptheworld.labstoreshopper.com/api/markers/api_stw.php?p=registrar";
                
                let locale: NSLocale = NSLocale.currentLocale();
                let currencyCode = locale.objectForKey(NSLocaleCurrencyCode) as! String;
                let languageCode = locale.objectForKey(NSLocaleLanguageCode) as! String;
                var language: String = locale.displayNameForKey(NSLocaleLanguageCode, value: languageCode)!
                

                var datosEnvio:NSMutableString = "usuario=";
                datosEnvio.appendString(user!);
                datosEnvio.appendString("&correo=");
                datosEnvio.appendString(email!);
                datosEnvio.appendString("&password=");
                datosEnvio.appendString(pw!);
                datosEnvio.appendString("&language=");
                datosEnvio.appendString(language);
                datosEnvio.appendString("&currency=");
                datosEnvio.appendString(currencyCode);
                
                
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
        } else {
            UIAlertView(title: NSLocalizedString("Incomplete Data", comment: "Incomplete Data"), message: NSLocalizedString("Fill out all fields , please", comment: "Fill out all fields , please"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        }
    }
    
    func comprobarRespuesta(){

        loading.hidden = true;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;

        if (self.respuestaPHP == "existe_usuario") {
            UIAlertView(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("The username already exists.", comment: "The username already exists."), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        } else if (self.respuestaPHP == "existe_correo") {
            UIAlertView(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("There is a user registered with this email.", comment: "There is a user registered with this email."), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        } else {
            UIAlertView(title: NSLocalizedString("Congratulations!", comment: "Congratulations!"), message: NSLocalizedString("You just sign up for Shop The World.", comment: "You just sign up for Shop The World."), delegate: nil, cancelButtonTitle: NSLocalizedString("Sign In", comment: "Sign In")).show();
            
            let signIn = self.storyboard?.instantiateViewControllerWithIdentifier("signIn") as! InicioViewController;
            signIn.navigationItem.setHidesBackButton(true, animated:false);
            self.navigationController?.pushViewController(signIn, animated: true);
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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
