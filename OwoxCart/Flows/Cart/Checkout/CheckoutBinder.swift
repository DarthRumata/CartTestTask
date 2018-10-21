//
//  CheckoutBinder.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 21-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//

import RxSwift

class CheckoutBinder: BaseBinder {
  
  private let model: CheckoutModelInterface
  
  init(model: CheckoutModelInterface) {
    self.model = model
  }
  
  // From Model
  
  func bindProductsTitlesLabel(_ observer: AnyObserver<String?>) {
    model.products
      .map { products in
        return products.reduce("", { (result, inCartProduct) in
          var result = result
          if !result.isEmpty {
            result += ", "
          }
          result += inCartProduct.product.title
          
          return result
        })
      }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  // To Model
  
}
