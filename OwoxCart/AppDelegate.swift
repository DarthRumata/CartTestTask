//
//  AppDelegate.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 16-10-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import UIKit
import Swinject
import SwinjectAutoregistration
import Core
import EventsTree

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private var assembler: Assembler!
  private let rootNode: EventNode = EventNode(parent: nil)
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Init Swinject
    assembler = Assembler.make(with: rootNode)
    DependencyHelper.registerFlowDependencies(with: assembler)
    
    startNavigation()
    
    return true
  }
  
  // Simplified app navigation(Demo)
  private func startNavigation() {
    let initialFlow = self.assembler.resolver.resolve(CartFlowCoordinator.self, argument: self.assembler.resolver)!
    let controller = initialFlow.makeFlow()
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = controller
    window!.makeKeyAndVisible()
  }
  
}
