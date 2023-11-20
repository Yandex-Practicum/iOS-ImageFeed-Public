//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 16.11.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "accessToken")
        }
        set {
            if let newValue = newValue {
                do {
                    let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "accessToken")
                    guard isSuccess else {
                        throw KeychainError.saveFailed
                    }
                } catch {
                    print("Ошибка сохранения в Keychain: \(error)")
                }
            }
        }
    }
}

enum KeychainError: Error {
    case saveFailed
}

