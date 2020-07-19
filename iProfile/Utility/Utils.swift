//
//  Utils.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import UIKit

class Utils: NSObject {

    static func showAlert(message: String,viewcontroller:UIViewController , action: UIAlertAction) {
        let alert = UIAlertController(title: Constants.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(action)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
    
}
