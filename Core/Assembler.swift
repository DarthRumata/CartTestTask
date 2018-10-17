//
//  Assembler.swift
//  Core
//
//  Created by Rumata on 3/16/18.
//  Copyright © 2018 Windmill. All rights reserved.
//

import Foundation
import Swinject
import EventsTree

public extension Assembler {

  public static func make(with rootNode: EventNode) -> Assembler {
    let rootContainer = Container()
    rootContainer.register(EventNode.self) { _ in
      return EventNode(parent: rootNode)
      }.inObjectScope(.transient)
    let assemblies: [Assembly] = [
      RepositoriesAssembly(),
      DomainServicesAssembly(),
      InfrastructureServicesAssembly()
    ]

    return Assembler(assemblies, container: rootContainer)
  }

}
