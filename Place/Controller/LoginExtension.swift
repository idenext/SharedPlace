//
//  LoginExtension.swift
//  Place
//
//  Created by Pierre Chamorro on 6/15/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData

extension LoginViewController{
    
    func createUser(user:String,password:String){
         UILoader.instance.showOverlay(view: self.view)
        Auth.auth().createUser(withEmail: user, password: password) {(
            result, error) in
            if(error == nil){
                UILoader.instance.finishOverlay()
                self.loginFirebase(user: user, password: password)
            }else{
                UIAlertView.instance.showAlertViewSimple(vc:self,title:"SharedPlace",message:error?.localizedDescription)
            }
        }
    }
    func loginFirebase(user:String,password:String){
        UILoader.instance.showOverlay(view: self.view)
        Auth.auth().signIn(withEmail: user, password: password) {(
            result, error) in
            
            UILoader.instance.finishOverlay()
            if(error == nil){
                self.seveData(email: result!.user.email!, uid: result!.user.uid)
                let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "tabNav") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
            }else{
                UIAlertView.instance.showAlertViewSimple(vc:self,title:"SharedPlace",message:error?.localizedDescription)
            }
        }
    }
    //MARK: - core data user
    func seveData(email:String,uid:String){
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        let task = NSManagedObject(entity: entity!, insertInto: managedContext)
        task.setValue(email, forKey: "email")
        task.setValue(uid, forKey: "uid")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
    }
    
    func setData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : "User")
        do {
            let results = try managedContext.fetch(fetchRequest)
            for task in results as! [NSManagedObject] {
                self.email = task.value(forKey: "email") as! String
                let uid = task.value(forKey: "uid") as! String
                print(self.email)
                print(uid)
                if(email != "" || email != nil){
                    let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "tabNav") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        } catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
    }
    
}
