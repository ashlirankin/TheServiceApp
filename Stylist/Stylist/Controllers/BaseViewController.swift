//
//  BaseViewController.swift
//  Stylist
//
//  Created by Ashli Rankin on 4/9/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

  let gradient = CAGradientLayer()
  var gradientSet = [[CGColor]]()
  var currentGradient = 0
  let color1 = #colorLiteral(red: 0.1528116562, green: 0.3392507715, blue: 1, alpha: 1).cgColor
  let color2 = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
  let color3 = #colorLiteral(red: 0.3056506849, green: 0.8034205004, blue: 0.5805864726, alpha: 1).cgColor
  
    override func viewDidLoad() {
        super.viewDidLoad()

      createGradientView()
    }
    
  func createGradientView(){
    
    
    gradientSet.append([color1, color3])    
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.frame = self.view.bounds
    gradient.colors = gradientSet[currentGradient]
    gradient.endPoint = CGPoint(x: 1, y: 1)
    gradient.drawsAsynchronously = true
    
    self.view.layer.insertSublayer(gradient, at: 0)
 
  }
  
}
extension UINavigationController{
  
  func setTransparentBackGround(){
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
}

