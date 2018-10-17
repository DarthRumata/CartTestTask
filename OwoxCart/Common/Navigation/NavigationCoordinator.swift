//
//  NavigationCoordinator.swift
//  Core
//
//  Created by Rumata on 3/16/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation
import UIKit
import EventsTree

public protocol NavigationFlow: DisposableFlow {
  func makeFlow() -> UIViewController
}
