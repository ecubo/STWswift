//
//  AddViewController.swift
//  Shop World
//
//  Created by Cubo, Emilio on 24/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit
import MapKit
import MobileCoreServices
import AVFoundation
import Photos

class AddViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UISearchBarDelegate {
    
    var currentPosition:CLLocationCoordinate2D?;
    var currentAddress:NSString?;
    let locationManager = CLLocationManager();
    var categories = [NSLocalizedString("Restaurant", comment: "Restaurant"),NSLocalizedString("Toys", comment: "Toys"),NSLocalizedString("Electronic", comment: "Electronic"),NSLocalizedString("Clothes", comment: "Clothes"),NSLocalizedString("Sports", comment: "Sports"),NSLocalizedString("Travel", comment: "Travel"),NSLocalizedString("Baby", comment: "Baby"),NSLocalizedString("Drugstore", comment: "Drugstore"),NSLocalizedString("Food", comment: "Food")];
    
    @IBOutlet var mapaAdd: MKMapView!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var txtAddress: UITextView!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var txtSelectCategory: UIButton!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var persiana: UIImageView!
    @IBOutlet var loading: UIActivityIndicatorView!
    

    var imagePicker: UIImagePickerController!
    var isImage:Bool = false;
    var respuestaPHP:NSString?;
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var newLat:CLLocationDegrees!;
    var newLon:CLLocationDegrees!;
    
    var changeLoc:Bool = false;
    
    var pais:String!;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("NEW PLACE", comment: "NEW PLACE");
        txtTitle.delegate = self;
//        txtAddress.delegate = self;
        
        picker.delegate = self
        picker.dataSource = self;
        imagePicker = UIImagePickerController()
        imagePicker.delegate  = self;
        
        let locale: NSLocale = NSLocale.currentLocale();
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        pais = countryCode;
        
        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);
        
        var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "saveMarker:")
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true);

        var widthTitle = txtTitle.frame.width;
        txtTitle.frame = CGRect(x: 0, y: 0, width: widthTitle, height: 42.00);
        txtTitle.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("Place Name", comment: "Place Name"),
            attributes:[NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]);
        txtTitle.layer.shadowOpacity = 1.0;
        txtTitle.layer.shadowRadius = 0.0;
        txtTitle.layer.shadowColor = UIColor(red: 0.0, green: 79.0/255.0, blue: 142.0/255.0, alpha: 1.0).CGColor;
        txtTitle.layer.shadowOffset = CGSizeMake(1.0, 1.0);

//        var widthAddress = txtAddress.frame.width;
//        txtAddress.frame = CGRect(x: 0, y: 0, width: widthAddress, height: 52.00);
//        txtAddress.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("Address", comment: "Address"),
//            attributes:[NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]);
        txtAddress.layer.shadowOpacity = 1.0;
        txtAddress.layer.shadowRadius = 0.0;
        txtAddress.layer.shadowColor = UIColor(red: 0.0, green: 79.0/255.0, blue: 142.0/255.0, alpha: 1.0).CGColor;
        txtAddress.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager.delegate = self;
        locationManager.startUpdatingLocation();

        if ( txtAddress.text == "" ) {
            txtAddress.text = currentAddress! as String;
        }
        
        if (!changeLoc) {
            locationManager.requestWhenInUseAuthorization();
            var currentLocation = CLLocation();
            
            if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
                var ubicacionActual = locationManager.location;
                newLon = ubicacionActual.coordinate.longitude
                newLat = ubicacionActual.coordinate.latitude
                
                currentPosition =  CLLocationCoordinate2D(latitude: newLat, longitude: newLon);
                var span = MKCoordinateSpanMake(0.005, 0.005);
                var region = MKCoordinateRegionMake(currentPosition!, span);
                mapaAdd.setRegion(region, animated: true);
            }
        }
        
        self.addDoneButtonOnKeyboard()
    }


    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        //doneToolbar.backgroundColor = UIColor(red: 0.0/255.0, green: 186.0/255.0, blue: 255.0/255.0, alpha: 1);
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        done.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Bryant-BoldCondensed", size: 16) ?? UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: UIColor(red: 0.0/255.0, green: 186.0/255.0, blue: 255.0/255.0, alpha: 1)], forState:.Normal);
        
        var items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = items as [AnyObject]
        doneToolbar.sizeToFit()
        
        //self.txtTitle.inputAccessoryView = doneToolbar
        self.txtAddress.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.txtAddress.resignFirstResponder()
        //self.txtTitle.resignFirstResponder()
    }

    override func viewDidDisappear(animated: Bool) {
        mapaAdd.showsUserLocation = false;
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtTitle.resignFirstResponder();
        txtAddress.resignFirstResponder();
        return true;
    }
    
    func saveMarker (sender:UIButton) {
        var user_id = NSUserDefaults.standardUserDefaults().stringForKey("id_usuario")!;
        let newTitle:String = txtTitle.text;
        let newAddress:String = txtAddress.text;
        //var newImage:UIImage = picture.image!;
        
//        let originImage = picture.image;
//        let crop:CGRect = picture.frame;
//        let imageRef:CGImage = CGImageCreateWithImageInRect(originImage?.CGImage, crop);
//        var newImage:UIImage = UIImage(CGImage: imageRef)!;
        
        var newImage:UIImage = RBResizeImage(picture.image!, targetSize: picture.frame.size);
        
        var newCat:String = txtSelectCategory.currentTitle!;
        
        if (newTitle != "") {
            /* TITULO */
            if (newAddress != "") {
                /* DIRECCION */
                if (isImage) {
                    /* IMAGEN */
                    
                    if (newCat != NSLocalizedString("Select Category", comment: "Select Category")) {
                        /* CATEGORIA */
                        switch (newCat) {
                        case categories[0]:
                            newCat = "restaurante";
                            break;
                        case categories[1]:
                            newCat = "toys";
                            break;
                        case categories[2]:
                            newCat = "electronic";
                            break;
                        case categories[3]:
                            newCat = "clothes";
                            break;
                        case categories[4]:
                            newCat = "sports";
                            break;
                        case categories[5]:
                            newCat = "travel";
                            break;
                        case categories[6]:
                            newCat = "baby";
                            break;
                        case categories[7]:
                            newCat = "drugstore";
                            break;
                        case categories[8]:
                            newCat = "food";
                            break;
                        default:
                            break;
                        }
                       
                        let myUrl = NSURL(string: "http://shoptheworld.labstoreshopper.com/api/markers/api_stw.php?p=insertar");
                        let request = NSMutableURLRequest(URL:myUrl!);
                        request.HTTPMethod = "POST";
                        
                        let param = [
                            "latitude":newLat,
                            "longitude":newLon,
                            "title":newTitle,
                            "address":newAddress,
                            "icon":newCat,
                            "user_id":user_id,
                            "pais":pais
                        ]
                        
                        let boundary = generateBoundaryString()
                        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                        let imageData = UIImageJPEGRepresentation(newImage, 1)
                        
                        request.HTTPBody = createBodyWithParameters(param, filePathKey: "image", imageDataKey: imageData, boundary: boundary);
                        
                        loading.hidden = false;
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

                        
                        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                            data, response, error in

                            if error != nil {
                                println("Error")
                                UIAlertView(title: "Error", message: NSLocalizedString("Failed to connect. Please try again later", comment: "Failed to connect. Please try again later"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
                                return
                            }
                            self.respuestaPHP = NSString(data: data, encoding: NSUTF8StringEncoding);
                            dispatch_async(dispatch_get_main_queue(), {
                                self.loading.hidden = true;
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                                var coordinates = CLLocationCoordinate2D(latitude: self.newLat, longitude: self.newLon);
                                self.comprobarRespuesta(newTitle);
                            });
                        }
                        task.resume();

                    } else {
                        UIAlertView(title: NSLocalizedString("Category", comment: "Category"), message: NSLocalizedString("Select a category, please", comment: "Select a category, please"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
                    }
                } else {
                    UIAlertView(title: NSLocalizedString("Image", comment: "Image"), message: NSLocalizedString("Select an image for the place, please", comment: "Select an image for the place, please"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
                }
            } else {
                UIAlertView(title: NSLocalizedString("Address", comment: "Address"), message: NSLocalizedString("Select the place address, please", comment: "Select the place address, please"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
            }
        } else {
            UIAlertView(title: NSLocalizedString("Place Name", comment: "Place Name"), message: NSLocalizedString("Select the name place, please", comment: "Select the name place, please"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        }
        


    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func createBodyWithParameters(parameters: NSDictionary?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "currentMarker.jpg"
        let mimetype = "image/jpeg"
        
        
        body.appendString("--\(boundary)\r\n")
        
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")

        return body
    }
    
    func comprobarRespuesta (newTitle:String) {
        println("\(respuestaPHP!)")
        if (respuestaPHP! == "ok") {
            UIAlertView(title: newTitle, message: NSLocalizedString("Place added", comment: "Place added"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();

            let aMap = navigationController!.viewControllers.first as! MapViewController;
            aMap.fromAdd = true;
            aMap.mapView.hidden = false;
            aMap.tableView.hidden = true;
            aMap.control.selectedSegmentIndex = 0;

            navigationController?.popToRootViewControllerAnimated(true);
        }
        else {
            UIAlertView(title: "Error", message: NSLocalizedString("Failed to connect. Please try again later", comment: "Failed to connect. Please try again later"), delegate: nil, cancelButtonTitle: NSLocalizedString("Done", comment: "Done")).show();
        }
    }
    
    
    // MARK: - Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            //let hue = CGFloat(row)/CGFloat(categories.count)
            //pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = categories[row]
        let pickerFont = UIFont(name: "Bryant-MediumCondensed", size: 20) ?? UIFont.systemFontOfSize(20);
        
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle;
        textStyle.alignment = NSTextAlignment.Center;
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:pickerFont,NSForegroundColorAttributeName:UIColor(red: 0.0/255.0, green: 79.0/255.0, blue: 142.0/255.0, alpha: 1.0), NSParagraphStyleAttributeName:textStyle])
        
        //This way you can set text for your label.
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picker.hidden = true;
        txtSelectCategory.setTitle(categories[row], forState: UIControlState.Normal);
    }

    @IBAction func selectCategory(sender: UIButton) {
        txtAddress.resignFirstResponder();
        txtTitle.resignFirstResponder();
        picker.hidden = false;
    }
    
    @IBAction func takePicture(sender: UIButton) {
        var actionSheet = UIAlertController(title: NSLocalizedString("Photo", comment: "Photo"), message: NSLocalizedString("Choose a photo for the new place", comment: "Choose a photo for the new place"), preferredStyle: UIAlertControllerStyle.ActionSheet);

        let fromCamera = UIAlertAction(title: NSLocalizedString("Take Photo", comment: "Take Photo"), style: UIAlertActionStyle.Default) { (ACTION) in
            
            let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)

            if status == AVAuthorizationStatus.Authorized {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                self.imagePicker.mediaTypes = [kUTTypeImage as NSString];
                // self.imagePicker.allowsEditing = true;
                self.presentViewController(self.imagePicker, animated: true, completion: nil);
            } else if status == AVAuthorizationStatus.NotDetermined {
                // Request permission
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                    if granted {
                        self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                        self.imagePicker.mediaTypes = [kUTTypeImage as NSString];
                        // self.imagePicker.allowsEditing = true;
                        self.presentViewController(self.imagePicker, animated: true, completion: nil);
                    }
                })
            } else {
                UIAlertView(title: NSLocalizedString("Shop The World requires camera access", comment: "Shop The World requires camera access"), message: NSLocalizedString("Please, go to settings and allows camera access", comment: "Please, go to settings and allows camera access"), delegate: self, cancelButtonTitle: NSLocalizedString("Done", comment: "Done"), otherButtonTitles: NSLocalizedString("Settings", comment: "Settings")).show();
            }
            
        };
        let fromLibrary = UIAlertAction(title: NSLocalizedString("Select from Library", comment: "Select from Library"), style: UIAlertActionStyle.Default) { (ACTION) in
            
            let status = PHPhotoLibrary.authorizationStatus();
            
            if(status == PHAuthorizationStatus.Authorized) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                self.imagePicker.mediaTypes = [kUTTypeImage as NSString];
                // self.imagePicker.allowsEditing = true;
                self.presentViewController(self.imagePicker, animated: true, completion: nil);
            } else if status == PHAuthorizationStatus.NotDetermined {
                // Request permission
                PHPhotoLibrary.requestAuthorization(self.requestAuthorizationHandler);

            } else {
                UIAlertView(title: NSLocalizedString("Shop The World requires photos access", comment: "Shop The World requires photos access"), message: NSLocalizedString("Please, go to settings and allows photos access", comment: "Please, go to settings and allows photos access"), delegate: self, cancelButtonTitle: NSLocalizedString("Done", comment: "Done"), otherButtonTitles: NSLocalizedString("Settings", comment: "Settings")).show();
            }
        };

        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIAlertActionStyle.Cancel) { (ACTION) in
        };

        actionSheet.addAction(fromCamera);
        actionSheet.addAction(fromLibrary);
        actionSheet.addAction(cancelButton);
        self.presentViewController(actionSheet, animated: true, completion: nil);
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex != 0) {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!);
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus)
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            self.imagePicker.mediaTypes = [kUTTypeImage as NSString];
            // imagePicker.allowsEditing = true;
            self.presentViewController(self.imagePicker, animated: true, completion: nil);
        }
    }
    
//    imagePicker =  UIImagePickerController()
//    imagePicker.delegate = self
//    imagePicker.sourceType = .Camera
//    
//    presentViewController(imagePicker, animated: true, completion: nil)

    
//    @IBAction func takeFromLibrary(sender: UIButton) {
//        imagePicker =  UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .PhotoLibrary
//        var image = UIImage(named: "toldo");
//
//        presentViewController(imagePicker, animated: true, completion: nil)
//    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil);

        // GUARDAR IMAGEN
        // UIImageWriteToSavedPhotosAlbum(picture.image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)

        let mediaType = info[UIImagePickerControllerMediaType] as! NSString;
        if mediaType.isEqualToString(kUTTypeImage as! String){
            picture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            if (picker.sourceType != .PhotoLibrary) {
                CustomPhotoAlbum.sharedInstance.saveImage(picture.image!);
            }
            isImage = true;
        }
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width*2  / image.size.width
        let heightRatio = targetSize.height*2 / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, 640, 400)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func searchLocation(sender: UIButton) {
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        // Present the view controller
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        loading.hidden = false;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapaAdd.annotations.count != 0 {
            annotation = self.mapaAdd.annotations[0] as! MKAnnotation
            self.mapaAdd.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                UIAlertView(title: nil, message: NSLocalizedString("Place not found", comment: "Place not found"), delegate: self, cancelButtonTitle: NSLocalizedString("Try again", comment: "Try again")).show()
                self.loading.hidden = true;
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                return
            }
            //3
            self.loading.hidden = true;
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)
            
            self.newLat = localSearchResponse.boundingRegion.center.latitude;
            self.newLon = localSearchResponse.boundingRegion.center.longitude;
            
            self.changeLoc = true;
            
            var newLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.newLat, longitude: self.newLon)
            var span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005);

            var region = MKCoordinateRegionMake(newLocation, span);
            self.mapaAdd.setRegion(region, animated: true);
            
            self.getPlacemarkFromLocation(CLLocation(latitude: self.newLat, longitude: self.newLon));
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapaAdd.centerCoordinate = self.pointAnnotation.coordinate
            self.mapaAdd.addAnnotation(self.pinAnnotationView.annotation)
        }
    }
    
    func getPlacemarkFromLocation(location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm);
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        txtAddress.text = "\(placemark.thoroughfare), \(placemark.subThoroughfare)\r\n\(placemark.postalCode). \(placemark.locality)\r\n\(placemark.country)";
        pais = placemark.ISOcountryCode;
    }


    
    
    func showAddPinViewController(placemark:CLPlacemark){
        self.performSegueWithIdentifier("add", sender: placemark)
    }

    
    // PARA GUARDAR IMAGEN
//    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
//        dispatch_async(dispatch_get_main_queue(), {
//            UIAlertView(title: "Success", message: "This image has been saved to your Camera Roll successfully", delegate: nil, cancelButtonTitle: "Close").show()
//        })
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}