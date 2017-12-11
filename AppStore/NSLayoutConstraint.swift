//
//  NSLayoutConstraint.swift
//  AppStore
//
//  Created by seojiwon on 2017. 12. 8..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func changeMultiPlier(change :CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        
        let constraint = NSLayoutConstraint(item: firstItem as Any,
                                            attribute: firstAttribute,
                                            relatedBy: relation,
                                            toItem: secondItem,
                                            attribute: secondAttribute,
                                            multiplier: change,
                                            constant: constant)
        constraint.priority = priority
        constraint.shouldBeArchived = shouldBeArchived
        constraint.identifier = identifier
        
        NSLayoutConstraint.activate([constraint])
        
        return constraint
    }
}
