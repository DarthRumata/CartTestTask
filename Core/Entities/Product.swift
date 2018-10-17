//
//  Product.swift
//  Core
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import Unbox

struct Product {
  
  let identifier: Double
  let title: String
  let price: Float
  let oldPrice: Float?
  let image: URL
  
}

extension Product: Unboxable {
  
  init(unboxer: Unboxer) throws {
    identifier = try unboxer.unbox(key: "id")
    title = try unboxer.unbox(key: "title")
    price = try unboxer.unbox(key: "price")
    oldPrice = unboxer.unbox(key: "old_price")
    image = try unboxer.unbox(key: "image")
  }
  
}
