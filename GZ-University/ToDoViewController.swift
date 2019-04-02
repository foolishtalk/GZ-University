////
////  ViewController.swift
////  HighSchool
////
////  Created by Fidetro on 2018/11/11.
////  Copyright © 2018 karim. All rights reserved.
////

import UIKit
import CoreLocation
import AMapSearchKit
class ToDoViewController: UIViewController,AMapSearchDelegate {
    
    let search = AMapSearchAPI.init()
    var json = try! JSONSerialization.jsonObject(with: try! Data.init(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "query.json", ofType: nil)!)), options: .allowFragments) as! [[String:Any]]
    var call_block : ((_ address:String,_ latitude:CGFloat,_ longitude:CGFloat)->())?=nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        var count = 0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            self.refresh()
        })

//        json

    }

    func refresh() {
        
        
        
        for  dict in json {
            let schoolname = dict["schoolname"] as! String
            let request = AMapGeocodeSearchRequest()
            request.address = schoolname
            request.city = "广州"
            search!.aMapGeocodeSearch(request)
            search!.delegate = self
            call_block = { [weak self](address,latitude,longitude) in
                for var newD in self!.json {
                    if (newD["schoolname"] as! String) == address,latitude != 0 {
                        newD["latitude"] = latitude
                        newD["longitude"] = longitude
                        return
                    }
                    
                }
            }

            //            CLGeocoder().geocodeAddressString(dict["schoolname"] as! String) { (placemarks, error) in
            //                count+=1
            //                print(count)
            //                if let error = error {
            //                    print("\(error)"+schoolname+"\(number)")
            //                    self.newJson.append(dict)
            //                    return
            //                }
            //
            //
            //
            //                if let placemarks = placemarks {
            //                    if let location = placemarks.first?.location{
            //                       dict["latitude"] = location.coordinate.latitude
            //                        dict["longitude"] = location.coordinate.longitude
            //                    }else{
            //                        print(schoolname+"\(number)")
            //                    }
            //                }else{
            //                    print(schoolname+"\(number)")
            //                }
            //                self.newJson.append(dict)
            //            }
        }
    }

    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count == 0 {
            print("错误 "+request.address)
            if let call_block = call_block {
                call_block(request.address,0,0)
            }
            return
        }

        if let call_block = call_block {
            call_block(request.address,response.geocodes.first!.location.latitude,response.geocodes.first!.location.longitude)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

       json.sort { (last, next) -> Bool in
           return Int(last["schoolid"]as!String)! < Int(next["schoolid"]as!String)!
        }

        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let writeData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        try! writeData.write(to: URL.init(fileURLWithPath: documentDirectory+"/test.json"))
        print(documentDirectory+"/test.json")
    }

}

