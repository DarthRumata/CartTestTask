//
//  BehaviorSubject.swift
//  Hemi-sync
//
//  Created by Stas Kirichok on 35//18.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import RxSwift

public extension BehaviorSubject {
  
  // swiftlint:disable force_try
  public func unsafeValue() -> Element {
    return try! value()
  }
  
}
