//
//  InCartProduct.swift
//  Core
//
//  Created by Stas Kirichok on 20-10-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import Unbox

public struct InCartProduct {
  
  public let product: Product
  public var quantity: Int = 1
  
  public init(product: Product) {
    self.product = product
  }
  
}

extension InCartProduct: Unboxable {
  
  public init(unboxer: Unboxer) throws {
    product = try unboxer.unbox(key: "product")
    quantity = try unboxer.unbox(key: "quantity")
  }
  
}
