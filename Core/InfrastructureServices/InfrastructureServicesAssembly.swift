//
//  InfrastructureServicesAssembly.swift
//  Core
//
//  Created by Rumata on 3/16/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class InfrastructureServicesAssembly: Assembly {

  func assemble(container: Container) {
    container.autoregister(FileService.self, initializer: FileService.init).inObjectScope(.container)
  }

}
