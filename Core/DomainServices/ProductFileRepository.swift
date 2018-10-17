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

class ProductFileRepository {
  
  private let fileService: FileService
  
  init(fileService: FileService) {
    self.fileService = fileService
  }
  
  func getInitialProducts() -> Single<[Product]> {
    return loadProductsFromFile(withName: "cart")
  }
  
  func getAllProducts() -> Single<[Product]> {
    return loadProductsFromFile(withName: "products")
  }
  
  private func loadProductsFromFile(withName fileName: String) -> Single<[Product]> {
    return Single.create { [unowned self] observer in
      do {
        let data = try self.fileService.readTextFileInBundle(withName: fileName, fileType: FileType.json)
        let products: [Product] = try unbox(data: data)
        observer(.success(products))
      } catch let error {
        observer(.error(error))
      }
      
      return Disposables.create()
    }
  }
  
}
