//
//  ViewController.swift
//  Tutorial-MapKitSwift
//
//  Created by Cubo, Emilio on 16/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NSXMLParserDelegate, UIAlertViewDelegate {
    
    // MARK: - Variables Globales
    var listAnnotation:[Annotation] = [];
    var categories = [[NSLocalizedString("All", comment: "All"),NSLocalizedString("Labstore Network", comment: "Labstore Network"),NSLocalizedString("Restaurant", comment: "Restaurant"),NSLocalizedString("Toys", comment: "Toys"),NSLocalizedString("Electronic", comment: "Electronic"),NSLocalizedString("Clothes", comment: "Clothes"),NSLocalizedString("Sports", comment: "Sports"),NSLocalizedString("Travel", comment: "Travel"),NSLocalizedString("Baby", comment: "Baby"),NSLocalizedString("Drugstore", comment: "Drugstore"),NSLocalizedString("Food", comment: "Food")],[NSLocalizedString("All", comment: "All"),NSLocalizedString("Spain", comment: "Spain"),NSLocalizedString("Belgium", comment: "Belgium"),NSLocalizedString("Austria", comment: "Austria"),NSLocalizedString("Czech Republic", comment: "Czech Republic"),NSLocalizedString("Hungary", comment: "Hungary"),NSLocalizedString("Russia", comment: "Russia"),NSLocalizedString("China", comment: "China"),NSLocalizedString("Thailand", comment: "Thailand"),NSLocalizedString("Philippines", comment: "Philippines"),NSLocalizedString("Singapour", comment: "Singapur"),NSLocalizedString("Australia", comment: "Australia"),NSLocalizedString("South Africa", comment: "South Africa"),NSLocalizedString("United States", comment: "United States"),NSLocalizedString("Puerto Rico", comment: "Puerto Rico"),NSLocalizedString("Mexico", comment: "Mexico"),NSLocalizedString("Colombia", comment: "Colombia"),NSLocalizedString("Brazil", comment: "Brazil"),NSLocalizedString("Argentina", comment: "Argentina"),NSLocalizedString("Chile", comment: "Chile")]];
    
    var lon:CLLocationDegrees?;
    var lat:CLLocationDegrees?;
    var location:String?;
    let locManager = CLLocationManager();
    var initStatus:CLAuthorizationStatus?;
    var ubicacion:CLLocationCoordinate2D?;
    var span: MKCoordinateSpan?;
    var region: MKCoordinateRegion?
    var currentDirection:NSString?;
    
    var txtNode:NSMutableString = NSMutableString();
    var parser:NSXMLParser = NSXMLParser();
    var currentLat:CLLocationDegrees = 0;
    var currentLon:CLLocationDegrees = 0;
    var aclat:CLLocationDegrees = 0;
    var aclon:CLLocationDegrees = 0;
    var currentAnnotation:Annotation = Annotation();
    var baseURLImages:String = "http://shoptheworld.labstoreshopper.com/api/markers/uploads/";
    
    var fromAdd:Bool = false;
    var categoria:String!;
    var pais:String!;
    var categoryList:String!;
    
    var listOfices:NSMutableArray = [];
    var listRestaurant:NSMutableArray = [];
    var listToys:NSMutableArray = [];
    var listElectronic:NSMutableArray = [];
    var listClothes:NSMutableArray = [];
    var listSports:NSMutableArray = [];
    var listTravel:NSMutableArray = [];
    var listBaby:NSMutableArray = [];
    var listDrugstore:NSMutableArray = [];
    var listFood:NSMutableArray = [];
    
    
    // MARK: - Outlets
    @IBOutlet var mapView: UIView!
    @IBOutlet var tableView: UIView!
    @IBOutlet var control: UISegmentedControl!
    @IBOutlet var mapa: MKMapView!
    @IBOutlet var persiana: UIImageView!
    @IBOutlet var tableViewController: UITableView!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet weak var btnSelectPicker: UIButton!
    @IBOutlet var vistaPicker: UIView!
    @IBOutlet var btnCancelPicker: UIButton!
    
    // MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale: NSLocale = NSLocale.currentLocale();
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        categoryList = "";
        
        var myImage = UIImage(named: "persiana");
        var rect = CGSizeMake(UIScreen.mainScreen().bounds.width/3, 32)
        UIGraphicsBeginImageContextWithOptions(rect, false, 0.0);
        myImage?.drawInRect(CGRectMake(0, 0, rect.width, rect.height));
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        persiana.backgroundColor = UIColor(patternImage: newImage);
        
        mapa.delegate = self
        locManager.delegate = self;
        initStatus = CLLocationManager.authorizationStatus();
        
        tableViewController.delegate = self;
        tableViewController.dataSource = self;
        
        picker.dataSource = self
        picker.delegate = self

        vistaPicker.hidden = true;
        
        let imageLeftFilterButton = UIImage(named: "filter");
        let leftSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: imageLeftFilterButton, style: .Plain, target: self, action: "searchTapped:")
        
        let imageRightAddButton = UIImage(named: "addMarker");
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: imageRightAddButton, style: .Plain, target: self, action: "addMarker:")
        rightAddBarButtonItem.tintColor = UIColor.whiteColor();
        
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true);
        self.navigationItem.setLeftBarButtonItems([leftSearchBarButtonItem], animated: true);
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (listAnnotation.count == 0 || fromAdd) {
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            locManager.startMonitoringSignificantLocationChanges();
            deleteMarkers();
            refreshTableView();
        } else if (fromAdd) {
//            locManager.desiredAccuracy = kCLLocationAccuracyBest
//            locManager.startUpdatingLocation()
//            locManager.startMonitoringSignificantLocationChanges();
//            loading.hidden = false;
//            mapa.hidden = false;
//            control.hidden = false;
//            mapa.showsUserLocation = true;
            refreshTableView();
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        locManager.stopMonitoringSignificantLocationChanges();
        locManager.stopUpdatingLocation()
        mapa.showsUserLocation = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Mapa
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            mapView.deselectAnnotation(annotationView.annotation, animated: true);
            self.performSegueWithIdentifier("detailInfo", sender: annotationView)
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        ubicacion =  CLLocationCoordinate2D(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude);
        region = MKCoordinateRegionMake(ubicacion!, span!);
        mapa.setRegion(region!, animated: true)
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        for (var i:Int=0; i<views.count; i++) {
            var endFrame:CGRect = views[i].frame;
            (views[i] as! MKAnnotationView).frame = CGRectOffset(endFrame, 0, -500);
            
            UIView.animateWithDuration(0.5, animations: { (views[i] as! MKAnnotationView).frame = endFrame});
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let reusarId = "anotacion"
        
        var anotacionView = mapView.dequeueReusableAnnotationViewWithIdentifier(reusarId)
        if anotacionView == nil {
            anotacionView = MKAnnotationView(annotation: annotation, reuseIdentifier: reusarId)
            anotacionView.image = UIImage(named:"logo")
            anotacionView.canShowCallout = true;
            anotacionView.rightCalloutAccessoryView = UIButton.buttonWithType(.InfoDark) as! UIButton
        }
        else {
            anotacionView.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        anotacionView.image = UIImage(named:cpa.imageName);
        
        return anotacionView
    }
    
    
    // MARK: - Tabla
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (categoryList == "") {
            return 10;
        } else { return 1 }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // 1. Dequeue the custom header cell
        var headerCell:CustomHeaderTableViewCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! CustomHeaderTableViewCell;
        
        // 2. Set the various properties
        headerCell.titleHeader.sizeToFit();
        
        if (categoryList == "") {
            switch section {
            case 0:
                headerCell.titleHeader.text = NSLocalizedString("Labstore Network", comment: "Labstore Network");
                headerCell.imgHeader.image = UIImage(named: "logo2")
                break;
            case 1:
                headerCell.titleHeader.text = NSLocalizedString("Restaurant", comment: "Restaurant");
                headerCell.imgHeader.image = UIImage(named: "restaurante")
                break;
            case 2:
                headerCell.titleHeader.text = NSLocalizedString("Toys", comment: "Toys");
                headerCell.imgHeader.image = UIImage(named: "toys")
                break;
            case 3:
                headerCell.titleHeader.text = NSLocalizedString("Electronic", comment: "Electronic");
                headerCell.imgHeader.image = UIImage(named: "electronic")
                break;
            case 4:
                headerCell.titleHeader.text = NSLocalizedString("Clothes", comment: "Clothes");
                headerCell.imgHeader.image = UIImage(named: "clothes")
                break;
            case 5:
                headerCell.titleHeader.text = NSLocalizedString("Sports", comment: "Sports");
                headerCell.imgHeader.image = UIImage(named: "sports")
                break;
            case 6:
                headerCell.titleHeader.text = NSLocalizedString("Travel", comment: "Travel");
                headerCell.imgHeader.image = UIImage(named: "travel")
                break;
            case 7:
                headerCell.titleHeader.text = NSLocalizedString("Baby", comment: "Baby");
                headerCell.imgHeader.image = UIImage(named: "baby")
                break;
            case 8:
                headerCell.titleHeader.text = NSLocalizedString("Drugstore", comment: "Drugstore");
                headerCell.imgHeader.image = UIImage(named: "drugstore")
                break;
            case 9:
                headerCell.titleHeader.text = NSLocalizedString("Food", comment: "Food");
                headerCell.imgHeader.image = UIImage(named: "food")
                break;
            default:
                headerCell.titleHeader.text = "Section";
                headerCell.imgHeader.image = UIImage(named: "logo")
                break;
            }
        }
        else {
            switch categoryList {
            case "logo":
                headerCell.titleHeader.text = NSLocalizedString("Labstore Network", comment: "Labstore Network");
                headerCell.imgHeader.image = UIImage(named: "logo2")
                break;
            case "restaurante":
                headerCell.titleHeader.text = NSLocalizedString("Restaurant", comment: "Restaurant");
                headerCell.imgHeader.image = UIImage(named: "restaurante")
                break;
            case "toys":
                headerCell.titleHeader.text = NSLocalizedString("Toys", comment: "Toys");
                headerCell.imgHeader.image = UIImage(named: "toys")
                break;
            case "electronic":
                headerCell.titleHeader.text = NSLocalizedString("Electronic", comment: "Electronic");
                headerCell.imgHeader.image = UIImage(named: "electronic")
                break;
            case "clothes":
                headerCell.titleHeader.text = NSLocalizedString("Clothes", comment: "Clothes");
                headerCell.imgHeader.image = UIImage(named: "clothes")
                break;
            case "sports":
                headerCell.titleHeader.text = NSLocalizedString("Sports", comment: "Sports");
                headerCell.imgHeader.image = UIImage(named: "sports")
                break;
            case "travel":
                headerCell.titleHeader.text = NSLocalizedString("Travel", comment: "Travel");
                headerCell.imgHeader.image = UIImage(named: "travel")
                break;
            case "baby":
                headerCell.titleHeader.text = NSLocalizedString("Baby", comment: "Baby");
                headerCell.imgHeader.image = UIImage(named: "baby")
                break;
            case "drugstore":
                headerCell.titleHeader.text = NSLocalizedString("Drugstore", comment: "Drugstore");
                headerCell.imgHeader.image = UIImage(named: "drugstore")
                break;
            case "food":
                headerCell.titleHeader.text = NSLocalizedString("Food", comment: "Food");
                headerCell.imgHeader.image = UIImage(named: "food")
                break;
            default:
                headerCell.titleHeader.text = "Section";
                headerCell.imgHeader.image = UIImage(named: "logo")
                break;
            }
        }
        
        
        return headerCell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var x:Int!;
        
        if (categoryList == "") {
            switch section {
            case 0:
                x = getRows("logo");
                break;
            case 1:
                x = getRows("restaurante");
                break;
            case 2:
                x = getRows("toys");
                break;
            case 3:
                x = getRows("electronic");
                break;
            case 4:
                x = getRows("clothes");
                break;
            case 5:
                x = getRows("sports");
                break;
            case 6:
                x = getRows("travel");
                break;
            case 7:
                x = getRows("baby");
                break;
            case 8:
                x = getRows("drugstore");
                break;
            case 9:
                x = getRows("food");
                break;
            default:
                x = listAnnotation.count;
                break;
            }
        }
        else {
            x = getRows(categoryList);
        }
        
        return x!;
    }
    
    func getRows(icon:String) -> Int {
        var x:Int = 0;
        for (var i:Int = 0; i<listAnnotation.count; i++) {
            if (listAnnotation[i].iconImage == icon) {
                x++;
            }
        }
        return x;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableViewController.dequeueReusableCellWithIdentifier("cellmap") as! CeldaMapaTableViewCell;
        
        var annotation:Annotation;
        
        if (categoryList != "") {
            annotation = listAnnotation[indexPath.row];
        }
        else {
            switch indexPath.section {
            case 0:
                annotation = listOfices[indexPath.row] as! Annotation;
                break;
            case 1:
                annotation = listRestaurant[indexPath.row] as! Annotation;
                break;
            case 2:
                annotation = listToys[indexPath.row] as! Annotation;
                break;
            case 3:
                annotation = listElectronic[indexPath.row] as! Annotation;
                break;
            case 4:
                annotation = listClothes[indexPath.row] as! Annotation;
                break;
            case 5:
                annotation = listSports[indexPath.row] as! Annotation;
                break;
            case 6:
                annotation = listTravel[indexPath.row] as! Annotation;
                break;
            case 7:
                annotation = listBaby[indexPath.row] as! Annotation;
                break;
            case 8:
                annotation = listDrugstore[indexPath.row] as! Annotation;
                break;
            case 9:
                annotation = listFood[indexPath.row] as! Annotation;
                break;
            default:
                annotation = listAnnotation[indexPath.row];
                break;
            }
        }
        
        
        cell.txtCell.text = annotation.title;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        var annotation:Annotation!;
        
        if (categoryList == "") {
            switch indexPath.section {
            case 0:
                annotation = listOfices[indexPath.row] as! Annotation;
                break;
            case 1:
                annotation = listRestaurant[indexPath.row] as! Annotation;
                break;
            case 2:
                annotation = listToys[indexPath.row] as! Annotation;
                break;
            case 3:
                annotation = listElectronic[indexPath.row] as! Annotation;
                break;
            case 4:
                annotation = listClothes[indexPath.row] as! Annotation;
                break;
            case 5:
                annotation = listSports[indexPath.row] as! Annotation;
                break;
            case 6:
                annotation = listTravel[indexPath.row] as! Annotation;
                break;
            case 7:
                annotation = listBaby[indexPath.row] as! Annotation;
                break;
            case 8:
                annotation = listDrugstore[indexPath.row] as! Annotation;
                break;
            case 9:
                annotation = listFood[indexPath.row] as! Annotation;
                break;
            default:
                annotation = listAnnotation[indexPath.section] as Annotation;
                break;
            }
        }
        else {
            annotation = listAnnotation[indexPath.row] as Annotation;
        }
        
        
        self.performSegueWithIdentifier("detailInfo2", sender: annotation);
        
    }
    
    // MARK: - GoTo Vista Detalle
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "detailInfo") {
            var detailView = segue.destinationViewController as! DetailViewController;
            var currentAnnotation:CustomPointAnnotation = sender.annotation as! CustomPointAnnotation;
            detailView.annotation = currentAnnotation;
        } else if (segue.identifier == "detailInfo2") {
            var detailView = segue.destinationViewController as! DetailViewController;
            detailView.annotation2 = sender as? Annotation;
        } else if (segue.identifier == "addMarker") {
            var detailView = segue.destinationViewController as! AddViewController;
            detailView.currentPosition = ubicacion;
            detailView.currentAddress = currentDirection;
        }
    }
    
    
    // MARK: - Cambio Mapa/Tabla
    @IBAction func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.hidden = false;
            tableView.hidden = true;
            break;
        case 1:
            mapView.hidden = true;
            tableView.hidden = false;
            break;
        default:
            mapView.hidden = false;
            tableView.hidden = true;
            break;
        }
    }
    
    // MARK: - Localización de Posición
    func currentPosition() {
        locManager.requestWhenInUseAuthorization();
        var currentLocation = CLLocation();
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
            currentLocation = locManager.location;
            
            lon = currentLocation.coordinate.longitude;
            lat = currentLocation.coordinate.latitude;
            
            
            var currentPais:String!;
            currentPais = (NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String)!;
            
            if (pais != nil && pais != currentPais) {
                var nLat = listAnnotation[0].coordinates!.latitude;
                var nLon = listAnnotation[0].coordinates!.longitude;
                ubicacion = CLLocationCoordinate2D(latitude: nLat, longitude: nLon);
                span = MKCoordinateSpanMake(2.5, 2.5);
            }
            else {
                ubicacion =  CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude);
                span = MKCoordinateSpanMake(0.1, 0.1);
            }
            
            region = MKCoordinateRegionMake(ubicacion!, span!);
            
            if CLLocationCoordinate2DIsValid (ubicacion!) {
                mapa.setRegion(region!, animated: true);
            }
            
            mapa.showsUserLocation = true;
            locManager.stopUpdatingLocation();
        } else {
//            UIAlertView(title: NSLocalizedString("Shop The World needs to know your location", comment: "Shop The World needs to know your location"), message: NSLocalizedString("Please, go to settings and allows location access", comment: "Please, go to settings and allows location access"), delegate: self, cancelButtonTitle: NSLocalizedString("Done", comment: "Done"), otherButtonTitles: NSLocalizedString("Settings", comment: "Settings")).show();
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex != 0) {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!);
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
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
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        
        currentDirection = "\(placemark.thoroughfare), \(placemark.subThoroughfare)\r\n\(placemark.postalCode). \(placemark.locality)\r\n\(placemark.country)";
        pais = placemark.ISOcountryCode;
        
        deleteMarkers();
        refreshTableView();
        locManager.stopUpdatingLocation();
    }
    
    
    //MARK: - XML
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        txtNode = NSMutableString();
        if(elementName == "marker"){
            currentAnnotation = Annotation();
        }
        
    }
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        txtNode.appendString(string!);
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch(elementName){
        case "id":
            currentAnnotation.id = txtNode as String;
            break;
        case "latitude":
            currentLat = (txtNode as NSString).doubleValue;
            aclat = currentLat;
            break;
        case "longitude":
            currentLon = (txtNode as NSString).doubleValue;
            aclon = currentLon;
            currentAnnotation.coordinates = CLLocationCoordinate2DMake(aclat, aclon);
            break;
        case "title":
            currentAnnotation.title = txtNode as String;
            break;
        case "address":
            currentAnnotation.subtitle = txtNode as String;
            break;
        case "icon":
            currentAnnotation.iconImage = txtNode as String;
            break;
        case "image":
            currentAnnotation.image = txtNode as String;
            break;
        case "marker":
            listAnnotation.append(currentAnnotation);
            break;
        default:
            
            listOfices.removeAllObjects();
            listRestaurant.removeAllObjects();
            listToys.removeAllObjects();
            listElectronic.removeAllObjects();
            listClothes.removeAllObjects();
            listSports.removeAllObjects();
            listTravel.removeAllObjects();
            listBaby.removeAllObjects();
            listDrugstore.removeAllObjects();
            listFood.removeAllObjects();
            
            for (var i:Int = 0; i<listAnnotation.count; i++) {
                
                var annotation = CustomPointAnnotation()
                annotation.coordinate = listAnnotation[i].coordinates!;
                annotation.title = listAnnotation[i].title!;
                annotation.direccion = listAnnotation[i].subtitle!;
                annotation.imageName = listAnnotation[i].iconImage!;
                annotation.bkImage = listAnnotation[i].image!;
                mapa.addAnnotation(annotation);
                
                if(listAnnotation[i].iconImage == "logo") {
                    listOfices.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "drugstore") {
                    listDrugstore.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "restaurante"){
                    listRestaurant.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "electronic"){
                    listElectronic.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "toys"){
                    listToys.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "sports"){
                    listSports.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "clothes"){
                    listClothes.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "travel"){
                    listTravel.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "baby"){
                    listBaby.addObject(listAnnotation[i]);
                }
                else if (listAnnotation[i].iconImage == "food"){
                    listFood.addObject(listAnnotation[i]);
                }
                
            }
            
            loading.hidden = true;
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            mapa.hidden = false;
            control.hidden = false;
            currentPosition();
            
            tableViewController.reloadData();
            break;
        }
    }
    
    func refreshTableView() {
        listAnnotation = [];
        fromAdd = false;
        loading.hidden = false;
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;

        getMap();
        tableViewController.reloadData();
    }
    
    
    // MARK: - Obtener Annotations
    func getMap() {
        let user_id:String = NSUserDefaults.standardUserDefaults().stringForKey("id_usuario")!;
        parser = NSXMLParser(contentsOfURL: (NSURL(string: "http://shoptheworld.labstoreshopper.com/api/markers/api_stw.php?p=listar&user_id=\(user_id)&pais=\(pais)&categoria=\(categoryList)")))!;
        parser.delegate=self;
        parser.parse();
        println("OK")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (initStatus != CLLocationManager.authorizationStatus() && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
            currentPosition();
        }
    }
    
    
    // MARK: - Funcionalidades BarButton Items
    func searchTapped(sender:UIButton) {
        vistaPicker.hidden = false;
    }
    
    func addMarker (sender:UIButton) {
        self.performSegueWithIdentifier("addMarker", sender: self);
    }
    
    
    // MARK: - Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return categories.count;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories[component].count;
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        let titleData = categories[component][row]
        let pickerFont = UIFont(name: "Bryant-MediumCondensed", size: 20) ?? UIFont.systemFontOfSize(20);
        
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle;
        textStyle.alignment = NSTextAlignment.Center;
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:pickerFont,NSForegroundColorAttributeName:UIColor(red: 0.0/255.0, green: 79.0/255.0, blue: 142.0/255.0, alpha: 1.0), NSParagraphStyleAttributeName:textStyle])
        
        //This way you can set text for your label.
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
    }
    
    @IBAction func cancelPicker(sender: UIButton) {
        vistaPicker.hidden = true;
    }

    @IBAction func selectPicker(sender: UIButton) {
        vistaPicker.hidden = true;
        deleteMarkers();
        
        var categoriaActual = picker.selectedRowInComponent(0);
        var paisActual = picker.selectedRowInComponent(1);
                
        switch categoriaActual {
        case 0:
            categoryList = "";
            break;
        case 1:
            categoryList = "logo";
            break;
        case 2:
            categoryList = "restaurante";
            break;
        case 3:
            categoryList = "toys";
            break;
        case 4:
            categoryList = "electronic";
            break;
        case 5:
            categoryList = "clothes";
            break;
        case 6:
            categoryList = "sports";
            break;
        case 7:
            categoryList = "travel";
            break;
        case 8:
            categoryList = "baby";
            break;
        case 9:
            categoryList = "drugstore";
            break;
        case 10:
            categoryList = "food";
            break;
        default:
            categoryList = "";
            break;
        }
        
        switch paisActual {
        case 0:
            pais = "";
            break;
        case 1:
            pais = "ES";
            break;
        case 2:
            pais = "BE";
            break;
        case 3:
            pais = "AT";
            break;
        case 4:
            pais = "CZ";
            break;
        case 5:
            pais = "HU";
            break;
        case 6:
            pais = "RU";
            break;
        case 7:
            pais = "CN";
            break;
        case 8:
            pais = "TH";
            break;
        case 9:
            pais = "PH";
            break;
        case 10:
            pais = "SG";
            break;
        case 11:
            pais = "AU";
            break;
        case 12:
            pais = "ZA";
            break;
        case 13:
            pais = "US";
            break;
        case 14:
            pais = "PR";
            break;
        case 15:
            pais = "MX";
            break;
        case 16:
            pais = "CO";
            break;
        case 17:
            pais = "BR";
            break;
        case 18:
            pais = "AR";
            break;
        case 19:
            pais = "CL";
            break;
        default:
            pais = "";
            break;
        }
        
        refreshTableView();

    }
    
    func deleteMarkers() {
        for marker in mapa.annotations {
            if (marker as? MKUserLocation != mapa.userLocation) {
                mapa.removeAnnotation(marker as! MKAnnotation)
            }
        }
    }
    
}