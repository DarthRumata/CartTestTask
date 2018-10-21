//
//  UIView+Corners.swift
//  Onboarding
//
//  Created by Rumata on 3/27/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

  public func roundCorners() {
    roundCorners(radius: min(bounds.width, bounds.height) / 2)
  }

  public func roundCorners(radius: CGFloat) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
  }

}
