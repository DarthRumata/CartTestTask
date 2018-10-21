//
//  InCartProductFileRepository.swift
//  Core
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import RxSwift
import Unbox

public class InCartProductFileRepository {
  
  private let fileService: FileService
  
  init(fileService: FileService) {
    self.fileService = fileService
  }
  
  public func getCartProducts() -> Single<[InCartProduct]> {
    return Single.create { [unowned self] observer in
      do {
        let data = try self.fileService.readTextFileInBundle(withName: "cart", fileType: FileType.json)
        let products: [InCartProduct] = try unbox(data: data)
        observer(.success(products))
      } catch let error {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
}
