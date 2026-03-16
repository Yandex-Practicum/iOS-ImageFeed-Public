//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 18.11.2023.
//

import UIKit
import ProgressHUD

class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
