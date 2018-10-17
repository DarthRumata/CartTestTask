//
//  CartController.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//
//

import UIKit
import RxSwift

class CartController: UIViewController, DisposableFlowKeeper {

  var binder: CartBinder!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    linkToCurrentFlow()
  }

  deinit {
    unlinkFromCurrentFlow()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
    setupBindings()
  }

}

private extension CartController {

  func configureView() {
    // Configure static props of views
  }

  func setupBindings() {
    // Bind data streams to views
  }

}
