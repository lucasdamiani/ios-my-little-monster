//
//  DragImageView.swift
//  My Little Monster
//
//  Created by Lucas Damiani on 06/11/15.
//  Copyright © 2015 Lucas Damiani. All rights reserved.
//

import Foundation
import UIKit

class DragImageView: UIImageView {
    
    enum Notifications: String {
        case onTargetDropped
    }
    
    private var originalPosition = CGPoint.zero
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x, position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let position = touch.locationInView(self.superview)
            if CGRectContainsPoint(target.frame, position) {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: String(Notifications.onTargetDropped), object: nil))
            }
        }
        
        self.center = originalPosition
    }
}