//
//  MainController.swift
//  GZ-University
//
//  Created by Fidetro on 2019/1/16.
//  Copyright © 2019 karim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit
class MainController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    lazy var mapView: MKMapView = {
        var mapView = MKMapView.init(frame: UIScreen.main.bounds)
        mapView.showsCompass = false
        mapView.delegate = self
        
        return mapView
    }()
    
    lazy var userLocationButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage.init(named: "move_user_location_icon"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(moveToUserLoactionAction), for: .touchUpInside)
        return button
    }()
    
    var annotations = [MKPointAnnotation]()
    var userAnnotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    var schools = [School]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints{
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.height.equalTo(60)
        }
        refreshEvent()
        setNavigationStyle()
        moveToUserLoactionAction()
    }
    
    @objc func moveToUserLoactionAction() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    func refreshEvent() {
        let path = Bundle.main.path(forResource: "query", ofType: "json")!
        let data = try! Data.init(contentsOf: URL.init(fileURLWithPath: path))
        let decoder = JSONDecoder()
        schools = try! decoder.decode([School].self, from: data)
        
        for school in schools {
            if let latitude = school.latitude,let longitude = school.longitude {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                annotation.title = school.schoolname
                school.annotation = annotation
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func setNavigationStyle() {
        navigationItem.setupNavigationItem(items: ["附近"], orientation: .right, actions: [#selector(nearSchoolAction)], target: self)
    }
    
}

// MARK: setup view
extension MainController {
    
}

// MARK: Action
extension MainController {
    
    @objc func nearSchoolAction() {
        guard let annotations = mapView.annotations(in: self.mapView.visibleMapRect) as? Set<MKPointAnnotation> else { return }
         var nearSchools = [School]()
        for nearAnnotation in annotations {
            for school in schools {
               if school.annotation == nearAnnotation {
                    nearSchools.append(school)
                    break
                }
            }
        }
        
        guard nearSchools.count != 0 else { return  }
        let distanceVC = SortSchoolController.init(schools: nearSchools)
        distanceVC.modalPresentationStyle = .overFullScreen
        distanceVC.modalTransitionStyle = .coverVertical
        present(distanceVC, animated: true, completion: nil)
        distanceVC.didSelectSchool = { [weak self] (school) in
            if let annotation = school.annotation {
                self?.mapView.selectAnnotation(annotation, animated: true)
            }
            if let coordinate = school.coordinate() {
                self?.mapView.setCenter(coordinate, animated: true)
            }
        }
    }
    
    
    func calculateDistance() {
        for school in schools {
            let schoolLocation = CLLocation.init(latitude: school.latitude!, longitude: school.longitude!)
            let userLocation = CLLocation.init(latitude: userAnnotation.coordinate.latitude, longitude: userAnnotation.coordinate.longitude)
            school.distance = schoolLocation.distance(from: userLocation)
        }
    }
    
}

// MARK: view delegate
extension MainController {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if userAnnotation.coordinate.latitude != 0,userAnnotation.coordinate.longitude != 0 {
           userAnnotation.coordinate = mapView.centerCoordinate
            calculateDistance()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let kAnnotationIdentifier = "school"
        let kUserIdentifier = "user"
        
        if annotation as? MKPointAnnotation == userAnnotation {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kUserIdentifier) as? MKPinAnnotationView else {
                let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: kUserIdentifier)                
                annotationView.canShowCallout = false
                annotationView.pinTintColor = MKPinAnnotationView.purplePinColor()
                return annotationView
            }
            return annotationView
            
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kAnnotationIdentifier) as? MKPinAnnotationView else {
            let annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: kAnnotationIdentifier)
            annotationView.canShowCallout = true
            return annotationView
        }
        return annotationView
    }
    
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let first = locations.first {
            let viewRegion = MKCoordinateRegion(center: first.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(viewRegion, animated: true)
            mapView.removeAnnotation(userAnnotation)
            userAnnotation.coordinate = first.coordinate
            mapView.addAnnotation(userAnnotation)
            locationManager.stopUpdatingLocation()
            calculateDistance()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
}
