//
//  DependencyHelper.swift
//  Onboarding
//
//  Created by Rumata on 3/18/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

enum DependencyHelper {
  
  static func registerFlowDependencies(with assembler: Assembler) {
    assembler.apply(assemblies: [
      CartFlowAssembly()
      ])
  }
  
}
