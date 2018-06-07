
//
//  UsedAirdropAnnotation.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/6/7.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import MapKit

class UsedAirDropAnnotation: NSObject, MKAnnotation{
    var coordinate : CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
