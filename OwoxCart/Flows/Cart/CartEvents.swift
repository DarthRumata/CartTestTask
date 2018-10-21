//
//  CartEvents.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 21-10-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import EventsTree
import Core

enum CartEvents {
  struct OpenCheckout: Event {
    let products: [InCartProduct]
  }
}
