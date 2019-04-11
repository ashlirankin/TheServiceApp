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
  let color1 = #colorLiteral(red: 0.07409804314, green: 0.09361185879, blue: 1, alpha: 1).cgColor
  let color2 = #colorLiteral(red: 1, green: 0.9649639726, blue: 0, alpha: 1).cgColor
  let color3 = #colorLiteral(red: 0.2073303163, green: 0.06281155348, blue: 1, alpha: 1).cgColor
  
    override func viewDidLoad() {
        super.viewDidLoad()

      createGradientView()
    }
    
  func createGradientView(){
    
    
    gradientSet.append([color1,color2])
    gradientSet.append([color2,color3])
    gradientSet.append([color3,color1])
    
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
