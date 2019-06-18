//
//  MapExtension.swift
//  Place
//
//  Created by Pierre Chamorro on 6/17/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreData
import Firebase

extension MapViewController : GMSMapViewDelegate, CLLocationManagerDelegate{
//    MARK: Map
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.setCameraMap(lati: location.coordinate.latitude, long: location.coordinate.longitude)
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            locationManager.stopUpdatingLocation()
        }
    }
    func addMarker(lati:Double,long:Double,subtitle:String){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(CLLocationDegrees(lati), CLLocationDegrees(long))
        marker.snippet = subtitle
        marker.index(ofAccessibilityElement: index)
        marker.map = self.mapView
    }
    func setCameraMap(lati:Double,long:Double){
        let camera = GMSCameraPosition.camera(withLatitude: lati, longitude: long, zoom: 17.0)
        self.mapView?.animate(to: camera)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 140))
        view.addSubview(infoView)
        let index = Int(marker.snippet!)
        let dict = self.arrayPlace[index!] as! Dictionary<String,AnyObject>
        lblTitle.text = dict["description"] as? String
        lblSubtitle.text = dict["create"] as? String
        let image = NSMutableArray(array: dict["image"] as! Array)
        let strImage1 = image[0] as! String
        let strImage2 = image[1] as! String
        self.download(strImage: strImage1, imageView: image1)
        self.download(strImage: strImage2, imageView: image2)
        return view
    }
    
//    MARK: - Database Firebase
    func callPlaces(){
        refBD.child("place").observe(.childAdded, with: {(snapshot) in
            let dict:Dictionary<String,AnyObject>  = snapshot.value as! Dictionary<String,AnyObject>
            self.arrayPlace.add(dict)
            print(self.arrayPlace)
            for i in 0 ..< self.arrayPlace.count {
                let dict = self.arrayPlace[i] as! Dictionary<String,AnyObject>
                let create = String(i)
                let latitud = dict["latitud"] as! Double
                let longitud = dict["longitud"] as! Double
                self.addMarker(lati: latitud, long: longitud, subtitle: create)
            }
        })
    }
//    MARK: - Coredate delete user
    func deleteData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var managedContext : NSManagedObjectContext!
        managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
    }

    func download(strImage:String, imageView : UIImageView){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/\(strImage)"
         guard let fileURL = URL(string: filePath) else { return }
        Storage.storage().reference().child("images").child(strImage).write(toFile: fileURL, completion: { (url, error) in
            if let error = error {
                print("Error downloading:\(error)")
                return
            } else if let imagePath = url?.path {
                imageView.image = UIImage(contentsOfFile: imagePath)
            }
        })
    }
    
    
}

