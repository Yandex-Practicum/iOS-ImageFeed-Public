//
//  GradientView.swift
//  Image Feed
//
//  Created by Дмитрий Жуков on 3/5/24.
//

import UIKit

class GradientView: UIView {
    
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    @IBInspectable private var endColor:UIColor? {
        didSet {
            setupGradientColors()
        }
    }
     
      let gradientLayer = CAGradientLayer()
     
     override init(frame: CGRect) {
         super .init(frame: frame)
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setupGradient()
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         gradientLayer.frame = bounds
     }
     
    private func setupGradient() {
         self.layer.addSublayer(gradientLayer)
         setupGradientColors()
     }
     
    private func setupGradientColors() {
         if let startColor = startColor, let endColor = endColor{
             gradientLayer.colors = [startColor.cgColor, endColor.cgColor]

         }
     }
 }
