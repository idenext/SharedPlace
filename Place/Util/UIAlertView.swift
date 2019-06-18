//
//  UIAlertView.swift
//  Place
//
//  Created by Pierre Chamorro on 6/15/19.
//  Copyright © 2019 Pierre Chamorro. All rights reserved.
//

import Foundation
import UIKit

typealias AlertCompletionBlock = () -> Void

class UIAlertView{
    static var instance = UIAlertView()
    
    func showAlertViewSimple(vc:UIViewController,title: String? = nil, message: String? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            
        })
        vc.present(alert, animated: true)
    }
    
    func alertActionSheet(vc:UIViewController,completionCamera:@escaping AlertCompletionBlock,completionPhotoLibrary:@escaping AlertCompletionBlock){
        var alert = UIAlertController()
        alert = UIAlertController(title: "Place", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            completionPhotoLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            completionCamera()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        vc.present(alert, animated: true)
    }
    
}

