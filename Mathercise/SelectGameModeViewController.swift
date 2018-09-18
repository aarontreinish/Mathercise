//
//  SelectGameModeViewController.swift
//  Mathercise
//
//  Created by Aaron Treinish on 5/25/18.
//  Copyright © 2018 Aaron Treinish. All rights reserved.
//

import Foundation
import UIKit

class SelectGameModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        //background gradient
        //#3eb0f7
        let topColor = UIColor(red: (62/255.0), green: (176/255.0), blue: (247/255.0), alpha: 1)
        //#d0ecfd
        let bottomColor = UIColor(red: (208/255.0), green: (236/255.0), blue: (253/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
