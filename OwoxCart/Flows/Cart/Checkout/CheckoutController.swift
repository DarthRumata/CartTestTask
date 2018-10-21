//
//  CheckoutController.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 21-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//

import UIKit
import RxSwift
import SwiftGen

class CheckoutController: UIViewController, DisposableFlowKeeper {

  var binder: CheckoutBinder!

  @IBOutlet private weak var checkoutListLabel: UILabel!
  
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

private extension CheckoutController {

  func configureView() {
    title = L10n.Checkout.title
  }

  func setupBindings() {
    binder.bindProductsTitlesLabel(checkoutListLabel.rx.text.asObserver())
  }

}
