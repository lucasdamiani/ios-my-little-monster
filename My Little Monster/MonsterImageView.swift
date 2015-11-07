//
//  MonsterImageView.swift
//  My Little Monster
//
//  Created by Lucas Damiani on 06/11/15.
//  Copyright © 2015 Lucas Damiani. All rights reserved.
//

import Foundation
import UIKit

class MonsterImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        self.image = UIImage(named: "idle1.png")
        
        var images = [UIImage]()
        for i in 1...4 {
            let imageName = "idle\(i).png"
            if let image = UIImage(named: imageName) {
                images.append(image)
            }
        }
        
        self.animationImages = images
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        self.image = UIImage(named: "dead5.png")
        self.animationImages = nil
        
        var images = [UIImage]()
        for i in 1...5 {
            let imageName = "dead\(i).png"
            if let image = UIImage(named: imageName) {
                images.append(image)
            }
        }
        
        self.animationImages = images
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
}