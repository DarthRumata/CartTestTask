//
//  CartFlowAssembly.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import Core

// swiftlint:disable identifier_name
class CartFlowAssembly: Assembly {

  func assemble(container: Container) {
    container.autoregister(
      CartFlowCoordinator.self,
      argument: Resolver.self,
      initializer: CartFlowCoordinator.init
    )

    container.autoregister(CartModel.Dependencies.self, initializer: CartModel.Dependencies.init)
    container.autoregister(CartModelInterface.self, initializer: CartModel.init)
    container.autoregister(CartBinder.self, initializer: CartBinder.init)
    container.register(CartController.self) { _ in
      return StoryboardScene.Cart.cartController.instantiate()
      }.initCompleted { (r, controller) in
        controller.binder = r~>CartBinder.self
    }
    
    container.autoregister(CheckoutModelInterface.self, argument: [InCartProduct].self, initializer: CheckoutModel.init)
    container.autoregister(CheckoutBinder.self, argument: CheckoutModelInterface.self, initializer: CheckoutBinder.init)
    container.register(CheckoutController.self) { _ in
      return StoryboardScene.Cart.checkoutController.instantiate()
    }
  }

}
