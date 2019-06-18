//
//  MapViewController.swift
//  Place
//
//  Created by Pierre Chamorro on 6/17/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase


class MapViewController: UIViewController {
//    MARK: Outlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
//    MARK: variable
    var arrayPlace: NSMutableArray = []
    let locationManager = CLLocationManager()
    var refBD: DatabaseReference {
        return Database.database().reference()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        self.callPlaces()
    }
    
    //MARK: Actions
    @IBAction func close(_ sender: Any) {
        deleteData()
    }
}
