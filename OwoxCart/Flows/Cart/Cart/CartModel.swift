//
//  CartModel.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//
//

import UIKit
import RxSwift
import Core
import Unbox
import EventsTree

enum CartMode {
  case edit, view
}

protocol CartModelInterface: class {
  
  var products: Observable<[InCartProduct]> { get }
  var cartMode: Observable<CartMode> { get }
  var isReloadingCart: Observable<Bool> { get }
  
  var onProductQuantityChange: AnyObserver<InCartProduct> { get }
  var onAddProduct: AnyObserver<Void> { get }
  var onChangeCartMode: AnyObserver<Void> { get }
  var onCheckout: AnyObserver<Void> { get }
  var onDeleteProduct: AnyObserver<InCartProduct> { get }
  var onReloadCart: AnyObserver<Void> { get }
  
}

extension CartModel {
  struct Dependencies {
    let eventNode: EventNode
    let productRepository: ProductFileRepository
    let inCartProductRepository: InCartProductFileRepository
  }
}

class CartModel {
  
  private let dependencies: Dependencies
  
  private let cartProductsSubject = BehaviorSubject<[InCartProduct]>(value: [])
  private let allProductsSubject = BehaviorSubject<[Product]>(value: [])
  private let cartModeSubject = BehaviorSubject<CartMode>(value: .view)
  private let isReloadingCartSubject = BehaviorSubject<Bool>(value: false)
  private let disposeBag = DisposeBag()
  
  private let productQuantityChangeHandler = PublishSubject<InCartProduct>()
  private let addProductHandler = PublishSubject<Void>()
  private let changeCartModeHandler = PublishSubject<Void>()
  private let checkoutHandler = PublishSubject<Void>()
  private let deleteProductHandler = PublishSubject<InCartProduct>()
  private let reloadCartHandler = PublishSubject<Void>()
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    
    handleActions()
    loadInitialCart()
  }
  
}

extension CartModel: CartModelInterface {
  
  var isReloadingCart: Observable<Bool> {
    return isReloadingCartSubject.asObservable()
  }
  
  var cartMode: Observable<CartMode> {
    return cartModeSubject.asObservable()
  }
  
  var products: Observable<[InCartProduct]> {
    return cartProductsSubject.asObservable()
  }
  
  var onProductQuantityChange: AnyObserver<InCartProduct> {
    return productQuantityChangeHandler.asObserver()
  }
  
  var onAddProduct: AnyObserver<Void> {
    return addProductHandler.asObserver()
  }
  
  var onChangeCartMode: AnyObserver<Void> {
    return changeCartModeHandler.asObserver()
  }
  
  var onCheckout: AnyObserver<Void> {
    return checkoutHandler.asObserver()
  }
  
  var onDeleteProduct: AnyObserver<InCartProduct> {
    return deleteProductHandler.asObserver()
  }
  
  var onReloadCart: AnyObserver<Void> {
    return reloadCartHandler.asObserver()
  }
  
}

private extension CartModel {
  
  func loadInitialCart() {
    dependencies.inCartProductRepository.getCartProducts()
      .subscribe(onSuccess: { [weak self] (products) in
        self?.cartProductsSubject.onNext(products)
      }, onError: { (error) in
        print(error)
      })
      .disposed(by: disposeBag)
  }
  
  func handleActions() {
    handleProductQuantityChange()
    handleAddProduct()
    handleChangeCartMode()
    handleDeleteProduct()
    handleCheckout()
    handleReloadCart()
  }
  
  func handleProductQuantityChange() {
    productQuantityChangeHandler
      .subscribe(onNext: { [unowned self] inCartProduct in
        var currentCart = self.cartProductsSubject.unsafeValue()
        if let index = currentCart.firstIndex(where: { $0.product.identifier == inCartProduct.product.identifier }) {
          currentCart.remove(at: index)
          currentCart.insert(inCartProduct, at: index)
        }
        self.cartProductsSubject.onNext(currentCart)
      })
      .disposed(by: disposeBag)
  }
  
  func handleAddProduct() {
    addProductHandler
      .flatMap { [unowned self] _ -> Observable<[Product]> in
        if self.allProductsSubject.unsafeValue().isEmpty {
          return self.loadAllProducts()
        }
          
        return self.allProductsSubject.asObservable()
      }
      .subscribe(onNext: { products in
        var currentCart = self.cartProductsSubject.unsafeValue()
        let notAddedProducts = products.filter {
          !currentCart
            .map { $0.product.identifier }
            .contains($0.identifier)
        }
        if let randomProduct = notAddedProducts.randomElement() {
          currentCart.append(InCartProduct(product: randomProduct))
          self.cartProductsSubject.onNext(currentCart)
        }
      })
      .disposed(by: disposeBag)
  }
  
  func handleChangeCartMode() {
    changeCartModeHandler
      .subscribe(onNext: { [cartModeSubject] _ in
        let newMode: CartMode = cartModeSubject.unsafeValue() == .view ? .edit : .view
        cartModeSubject.onNext(newMode)
      })
      .disposed(by: disposeBag)
  }
  
  func handleDeleteProduct() {
    deleteProductHandler
      .subscribe(onNext: { productToDelete in
        var currentCart = self.cartProductsSubject.unsafeValue()
        currentCart = currentCart.filter { $0.product.identifier != productToDelete.product.identifier }
        self.cartProductsSubject.onNext(currentCart)
        if currentCart.isEmpty {
          self.cartModeSubject.onNext(.view)
        }
      })
      .disposed(by: disposeBag)
  }
  
  func handleCheckout() {
    checkoutHandler
      .subscribe(onNext: { [unowned self] _ in
        let event = CartEvents.OpenCheckout(products: self.cartProductsSubject.unsafeValue())
        self.dependencies.eventNode.raise(event: event)
      })
      .disposed(by: disposeBag)
  }
  
  func handleReloadCart() {
    reloadCartHandler
      .subscribe(onNext: { [unowned self] _ in
        self.isReloadingCartSubject.onNext(true)
        self.loadInitialCart()
        self.isReloadingCartSubject.onNext(false)
      })
      .disposed(by: disposeBag)
  }
  
  func loadAllProducts() -> Observable<[Product]> {
    return dependencies.productRepository.getAllProducts()
      .catchError { error  in
        print(error)
        return Single.never()
      }
      .asObservable()
      .do(onNext: { [unowned self] products in
        self.allProductsSubject.onNext(products)
      })
  }
  
}
