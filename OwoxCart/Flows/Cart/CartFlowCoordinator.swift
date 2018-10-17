//
//  CartFlowCoordinator.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import Core
import Swinject
import SwinjectAutoregistration
import EventsTree

class CartFlowCoordinator: NavigationFlow {

  private let resolver: Resolver
  private let eventNode: EventNode
  private var root: UIViewController!

  init(resolver: Resolver, eventNode: EventNode) {
    self.resolver = resolver
    self.eventNode = eventNode

    addToDisposePool()
    handleEvents()
  }

  func makeFlow() -> UIViewController {
    let controller: CartController = resolver~>
    root = controller
    return root
  }

}

private extension CartFlowCoordinator {

  func handleEvents() {

  }

}
