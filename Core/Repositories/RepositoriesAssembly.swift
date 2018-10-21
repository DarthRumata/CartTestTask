//
//  RepositoriesAssembly.swift
//  Core
//
//  Created by Rumata on 3/16/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class RepositoriesAssembly: Assembly {
  
  func assemble(container: Container) {
    container.autoregister(ProductFileRepository.self, initializer: ProductFileRepository.init)
    container.autoregister(InCartProductFileRepository.self, initializer: InCartProductFileRepository.init)
  }
  
}
