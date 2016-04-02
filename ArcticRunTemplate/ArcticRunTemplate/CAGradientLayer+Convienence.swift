//
//  CAGradientLayer+Convienence.swift
//  ArcticRunTemplate
//
//  Created by Matt Wiseman on 2016-03-30.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func blueblendColor() ->CAGradientLayer {
        
        let topColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let bottomColor = UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        
        let gradientColors : [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        //let gradientLocations : [Float] = [0.5, 1]
        
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x:0.0, y:1)
        gradientLayer.endPoint = CGPoint(x:0.5, y:0)
        
        return gradientLayer
        
    }
    
}
