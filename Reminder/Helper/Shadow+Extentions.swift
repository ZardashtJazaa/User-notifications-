//
//  Shadow+Extentions.swift
//  Reminder
//
//  Created by Zardasht  on 09/07/2022.
//

import Foundation
import UIKit

class ShadowView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializer()
    }
    
    
    private func initializer() {
        
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        layer.cornerRadius = 10
        
    }
    
}
