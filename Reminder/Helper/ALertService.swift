//
//  ALertService.swift
//  Reminder
//
//  Created by Zardasht  on 09/07/2022.
//

import Foundation
import UIKit

class AlertService {
    
    private init () {}
    static let shared = AlertService()
    
    static func actionSheet(in vc: UIViewController , title: String , completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            
            completion()
        }
        
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
         
        
    }
    
    
}
