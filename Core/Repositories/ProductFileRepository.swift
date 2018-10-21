//
//  ProductFileRepository.swift
//  Core
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import RxSwift
import Unbox

public class ProductFileRepository {
  
  private let fileService: FileService
  
  init(fileService: FileService) {
    self.fileService = fileService
  }
  
  public func getAllProducts() -> Single<[Product]> {
    return Single.create { [unowned self] observer in
      do {
        let data = try self.fileService.readTextFileInBundle(withName: "products", fileType: FileType.json)
        let products: [Product] = try unbox(data: data)
        observer(.success(products))
      } catch let error {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
}
