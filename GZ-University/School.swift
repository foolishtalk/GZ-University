//
//  School.swift
//  GZ-University
//
//  Created by Fidetro on 2019/1/16.
//  Copyright © 2019 karim. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class School: NSObject,Codable {
    
    var batch : String?
    var fencha : String?
    var latitude : CLLocationDegrees?
    var localprovince : String?
    var longitude : CLLocationDegrees?
    var max : String?
    var min : String?
    var num : String?
    var province : String?
    var provincescore : String?
    var schoolid : String?
    var schoolname : String?
    var studenttype : String?
    var var_origin : String?
    var varScore : String?
    var year : String?
    var distance : Double? = 0
    var annotation : MKPointAnnotation?
    
    enum CodingKeys: String, CodingKey {
        case batch = "batch"
        case fencha = "fencha"
        case latitude = "latitude"
        case localprovince = "localprovince"
        case longitude = "longitude"
        case max = "max"
        case min = "min"
        case num = "num"
        case province = "province"
        case provincescore = "provincescore"
        case schoolid = "schoolid"
        case schoolname = "schoolname"
        case studenttype = "studenttype"
        case var_origin = "var"
        case varScore = "var_score"
        case year = "year"
    }


    
    
    func coordinate() -> CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude  {
            return CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
}
