//
//  PlaceViewController.swift
//  Place
//
//  Created by Pierre Chamorro on 6/15/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase

class PlaceViewController: UIViewController , CLLocationManagerDelegate{

    //MARK: Outlet
    @IBOutlet weak var btnImage1: UIButton!
    @IBOutlet weak var btnImage2: UIButton!
    @IBOutlet weak var txtViewDescription: UITextView!
    
    //MARK: variable
    
    let locationManager = CLLocationManager()
    let picker = UIImagePickerController()
    var bntIndex = 0
    var namePhoto1 = ""
    var namePhoto2 = ""
    var latitud = 0.0
    var longitud = 0.0
    var email = ""

    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    var refBD: DatabaseReference {
        return Database.database().reference()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        picker.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    //MARK: Actions
    @IBAction func takeImage1(_ sender: Any) {
        bntIndex = 1
        namePhoto1 = "\(self.randomString(length: 10)).jpg"
        callAlert()
    }
    @IBAction func takeImage2(_ sender: Any) {
        bntIndex = 2
        namePhoto2 = "\(self.randomString(length: 10)).jpg"
        callAlert()
    }
    @IBAction func pressedAdd(_ sender: Any) {
        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000)
        refBD.child("place").child(String(timeStamp)).setValue(
            [ "create": email,
              "description": txtViewDescription.text,
              "latitud": latitud,
              "longitud": longitud,
              "image":[namePhoto1,namePhoto2]
            ]
        )
        self.txtViewDescription.text = ""
        self.btnImage1.setImage(UIImage(), for: .normal)
        self.btnImage2.setImage(UIImage(), for: .normal)
        UIAlertView.instance.showAlertViewSimple(vc: self, title: "Save", message: "successful")
    }
    
    //MARK: func
    func callAlert(){
        UIAlertView.instance.alertActionSheet(vc: self, completionCamera: {
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion:nil)
        }) {
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion:nil)
        }
    }
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    //MARK: close keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitud = location.coordinate.latitude
            longitud = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
        }
    }
}
