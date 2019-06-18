//
//  PlaceExtension.swift
//  Place
//
//  Created by Pierre Chamorro on 6/15/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension PlaceViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var name = ""
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if(bntIndex == 1){
                name =  namePhoto1
                btnImage1.setImage(pickedImage, for: .normal)
            }else{
                btnImage2.setImage(pickedImage, for: .normal)
                name =  namePhoto2
            }
            let imageData = pickedImage.jpegData(compressionQuality: 0.8)
            let uploadImageRef = imageReference.child(name)
            let uploadTask = uploadImageRef.putData(imageData!, metadata: nil) { (metadata, error) in
                UILoader.instance.finishOverlay()
                picker.dismiss(animated: true, completion: nil)
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                UILoader.instance.showOverlay(view: picker.view)
            }
            uploadTask.resume()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    //MARK: - core data user
    func setData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var managedContext : NSManagedObjectContext!
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : "User")
        do {
            let results = try managedContext.fetch(fetchRequest)
            for task in results as! [NSManagedObject] {
                self.email = task.value(forKey: "email") as! String
            }
        } catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
    }
}
