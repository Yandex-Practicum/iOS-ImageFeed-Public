//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 15.11.2023.
//
import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    private let showWebViewIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
             .lightContent
         }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowWebView" {
            let authView = segue.destination as? WebViewViewController
            if let unwrappedView = authView {
                unwrappedView.delegate = self
            }
        }
    }
}
    extension AuthViewController: WebViewViewControllerDelegate {
        func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
            delegate?.acceptToken(code: code)
        }
        
        func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
            dismiss(animated: true)
        }
    }
    
    protocol AuthViewControllerDelegate: AnyObject {
        func acceptToken(code: String)
    }
