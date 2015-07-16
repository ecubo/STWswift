//
//  Subcategoria.swift
//  Shop World
//
//  Created by Cubo, Emilio on 10/7/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class Subcategoria: NSObject {
    

    var id:String?;
    var nombre:String?;
    
    override init() {
    }
    
    convenience init(id:String, nombre:String) {
        self.init();
        self.id = id;
        self.nombre = nombre;
    }
   
}
