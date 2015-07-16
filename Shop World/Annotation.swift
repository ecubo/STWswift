//
//  Annotation.swift
//  Tutorial-MapKitSwift
//
//  Created by Cubo, Emilio on 16/6/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject {
    
    var coordinates:CLLocationCoordinate2D?;
    var title:String?;
    var subtitle:String?;
    var iconImage:String?;
    var image:String?;
    var id:String?;

    override init() {
    }
    
    convenience init(coordinates:CLLocationCoordinate2D, title:String, subtitle:String, iconImage:String, image:String?) {
        self.init();
        self.coordinates = coordinates;
        self.title = title;
        self.subtitle = subtitle;
        self.iconImage = iconImage;
        self.image = image;
//        self.image = getImage(image!);
    }
    
    func getImage(image:String)->UIImage {
        
        let encodedImageData:String = image;
        let imageData = NSData(base64EncodedString: encodedImageData, options: .allZeros);
        let currentImage = UIImage(data: imageData!);

        return currentImage!;
    }
   
}
