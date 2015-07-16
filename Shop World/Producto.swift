//
//  Producto.swift
//  Shop World
//
//  Created by Cubo, Emilio on 13/7/15.
//  Copyright (c) 2015 Emilio Cubo Ruiz. All rights reserved.
//

import UIKit

class Producto: NSObject {
   
    var id:String?;
    var nombre:String?;
    var tamagno:String?;
    var color:String?;
    
    override init() {
    }
    
    convenience init(id:String, nombre:String, tamagno:String, color:String) {
        self.init();
        self.id = id;
        self.nombre = nombre;
        self.tamagno = tamagno;
        self.color = color;
    }


}
