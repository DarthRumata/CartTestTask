//
//  CartBinder.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//
//

import RxSwift
import RxDataSources
import SwiftGen
import Core

class CartBinder: BaseBinder {
  
  private let model: CartModelInterface
  private let productsCountObservable: Observable<Int>
  private let isEditModeObservable: Observable<Bool>
  
  init(model: CartModelInterface) {
    self.model = model
    
    productsCountObservable = model.products.map { $0.count }
    isEditModeObservable = model.cartMode.map { $0 == .edit }
  }
  
  // From Model
  
  //swiftlint:disable line_length
  func bindDataSource(_ dataSource: RxCollectionViewSectionedReloadDataSource<ProductSection>, collection: Reactive<UICollectionView>) {
    model.products
      .map { (items) -> [ProductSection] in
        return [ProductSection(items: items)]
      }
      .bind(to: collection.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  func bindQuantityText(_ observer: AnyObserver<String?>) {
    productsCountObservable
      .map { L10n.Summary.quantityText($0) }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindTotalSumText(_ observer: AnyObserver<String?>) {
    model.products
      .map { products -> String in
        let sum = products.reduce(0, { (result, inCartProduct) in
          return result + inCartProduct.product.price * Float(inCartProduct.quantity)
        })
        return "\(sum) \(L10n.Currency.uah)"
      }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindSummaryIsHiddenProperty(_ observer: AnyObserver<Bool>) {
    Observable.combineLatest(productsCountObservable, isEditModeObservable)
      .map { (productsCount, isEditMode) in
        return productsCount == 0 || isEditMode
      }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindIsEditCellMode(_ observer: AnyObserver<Bool>) {
      isEditModeObservable
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindAddButtonIsEnabledProperty(_ observer: AnyObserver<Bool>) {
    isEditModeObservable
      .map { !$0 }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindEditButtonTitle(_ observer: AnyObserver<String>) {
    isEditModeObservable
      .map { $0 == true ? L10n.Buttons.done : L10n.Buttons.edit }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindEditButtonIsEnabledProperty(_ observer: AnyObserver<Bool>) {
    productsCountObservable
      .map { $0 > 0 }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindEmptyCartLabelIsHiddenProperty(_ observer: AnyObserver<Bool>) {
    productsCountObservable
      .map { $0 > 0 }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  func bindRefreshControlIsRefreshingProperty(_ observer: AnyObserver<Bool>) {
    model.isReloadingCart
      .filter { $0 == false }
      .bind(to: observer)
      .disposed(by: disposeBag)
  }
  
  // To Model
  
  func bindTapOnCheckoutButton(_ observable: Observable<Void>) {
    observable
      .bind(to: model.onCheckout)
      .disposed(by: disposeBag)
  }
  
  func bindProductQuantityChange(_ observable: Observable<InCartProduct>) {
    observable
      .bind(to: model.onProductQuantityChange)
      .disposed(by: disposeBag)
  }
  
  func bindTapOnAddProductButton(_ observable: Observable<Void>) {
    observable
      .bind(to: model.onAddProduct)
      .disposed(by: disposeBag)
  }
  
  func bindTapOnChangeModeButton(_ observable: Observable<Void>) {
    observable
      .bind(to: model.onChangeCartMode)
      .disposed(by: disposeBag)
  }
  
  func bindTapOnDeleteProductButton(_ observable: Observable<InCartProduct>) {
    observable
      .bind(to: model.onDeleteProduct)
      .disposed(by: disposeBag)
  }
  
  func bindReloadCart(_ observable: Observable<Void>) {
    observable
      .bind(to: model.onReloadCart)
      .disposed(by: disposeBag)
  }
  
}
