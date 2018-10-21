//
//  CheckoutModel.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 21-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//

import UIKit
import RxSwift
import Core

protocol CheckoutModelInterface: class {

}

class CheckoutModel {
  
  private let productsSubject: BehaviorSubject<[InCartProduct]>
  
  init(products: [InCartProduct]) {
    productsSubject = BehaviorSubject<[InCartProduct]>(value: products)
  }

}

extension CheckoutModel: CheckoutModelInterface {

}
