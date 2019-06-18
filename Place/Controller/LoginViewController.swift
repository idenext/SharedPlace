//
//  LoginViewController.swift
//  Place
//
//  Created by Pierre Chamorro on 6/15/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//

import UIKit
import CoreData
class LoginViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    //MARK: - var
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext : NSManagedObjectContext!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
    }
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    
    //MARK: - Actions
    @IBAction func enterLogin(_ sender: Any) {
        self.loginFirebase(user: txtUser.text!, password: txtPassword.text!)
    }
    @IBAction func enterRegister(_ sender: Any) {
        self.createUser(user: txtUser.text!, password: txtPassword.text!)
    }
    //MARK: - close keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

