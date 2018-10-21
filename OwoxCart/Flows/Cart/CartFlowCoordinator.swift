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
    let navigation = UINavigationController(rootViewController: controller)
    
    return navigation
  }

}

private extension CartFlowCoordinator {

  func handleEvents() {
    eventNode.addHandler { [weak self] (event: CartEvents.OpenCheckout) in
      self?.openCheckout(with: event.products)
    }
  }
  
  func openCheckout(with products: [InCartProduct]) {
    let controller: CheckoutController = resolver~>
    let model = resolver.resolve(CheckoutModelInterface.self, argument: products)!
    let binder = resolver.resolve(CheckoutBinder.self, argument: model)
    controller.binder = binder
    root.navigationController!.pushViewController(controller, animated: true)
  }

}
