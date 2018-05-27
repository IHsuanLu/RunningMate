//
//  AirDropAnnotation.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/24.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import MapKit

class AirDropAnnotation: NSObject, MKAnnotation{
    var coordinate : CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
