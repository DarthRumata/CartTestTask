//
//  CartController.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 17-10-2018.
//  Copyright (c) 2018 Stas Kirichok. All rights reserved.
//
//

import UIKit
import RxSwift
import SwiftGen
import RxDataSources
import Core
import RxCocoa

struct ProductSection: SectionModelType {
  
  private(set) var items: [InCartProduct]
  
  init(items: [InCartProduct]) {
    self.items = items
  }
  
  init(original: ProductSection, items: [InCartProduct]) {
    self = original
    self.items = items
  }
  
}

class CartController: UIViewController, DisposableFlowKeeper {
  
  var binder: CartBinder!
  
  @IBOutlet private weak var addButton: UIBarButtonItem!
  @IBOutlet private weak var editButton: UIBarButtonItem!
  @IBOutlet private weak var currentNavigationItem: UINavigationItem!
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var summaryContainer: UIView!
  @IBOutlet private weak var summaryLabel: UILabel!
  @IBOutlet private weak var quantityLabel: UILabel!
  @IBOutlet private weak var totalPriceLabel: UILabel!
  @IBOutlet private weak var checkoutButton: UIButton!
  @IBOutlet private weak var totalSumContainer: UIView!
  @IBOutlet private weak var emptyCartLabel: UILabel!
  
  private let quantityChangeRelay = PublishRelay<InCartProduct>()
  private let deleteProductRelay = PublishRelay<InCartProduct>()
  private let onEditModeChangeSubject = ReplaySubject<Bool>.create(bufferSize: 1)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    linkToCurrentFlow()
  }
  
  deinit {
    unlinkFromCurrentFlow()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureView()
    configureCollectionView()
    setupBindings()
  }
  
}

extension CartController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 20, height: 150)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
  
}

private extension CartController {
  
  func configureView() {
    currentNavigationItem.title = L10n.Cart.title
    
    addButton.title = L10n.Buttons.add
    totalSumContainer.layer.borderColor = UIColor.lightGray.cgColor
    totalSumContainer.layer.borderWidth = 1
    checkoutButton.roundCorners(radius: 5)
    checkoutButton.setTitle(L10n.Buttons.checkout, for: .normal)
    summaryLabel.text = L10n.Cart.summary
    emptyCartLabel.text = L10n.Cart.emptyCart
  }
  
  func configureCollectionView() {
    collectionView.delegate = self
    collectionView.register(cellType: ProductCell.self)
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .blue
    binder.bindReloadCart(refreshControl.rx.controlEvent(.valueChanged).asObservable())
    binder.bindRefreshControlIsRefreshingProperty(refreshControl.rx.isRefreshing.asObserver())
    
    collectionView.addSubview(refreshControl)
  }
  
  func setupBindings() {
    binder.bindDataSource(createDataSource(), collection: collectionView.rx)
    binder.bindQuantityText(quantityLabel.rx.text.asObserver())
    binder.bindTotalSumText(totalPriceLabel.rx.text.asObserver())
    binder.bindSummaryIsHiddenProperty(summaryContainer.rx.isHidden.asObserver())
    binder.bindProductQuantityChange(quantityChangeRelay.asObservable())
    binder.bindTapOnAddProductButton(addButton.rx.tap.asObservable())
    binder.bindTapOnChangeModeButton(editButton.rx.tap.asObservable())
    binder.bindIsEditCellMode(onEditModeChangeSubject.asObserver())
    binder.bindSummaryIsHiddenProperty(summaryContainer.rx.isHidden.asObserver())
    binder.bindAddButtonIsEnabledProperty(addButton.rx.isEnabled.asObserver())
    binder.bindEditButtonTitle(editButton.rx.title.asObserver())
    binder.bindTapOnDeleteProductButton(deleteProductRelay.asObservable())
    binder.bindEditButtonIsEnabledProperty(editButton.rx.isEnabled.asObserver())
    binder.bindEmptyCartLabelIsHiddenProperty(emptyCartLabel.rx.isHidden.asObserver())
    binder.bindTapOnCheckoutButton(checkoutButton.rx.tap.asObservable())
  }
  
  func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ProductSection> {
    let datasource = RxCollectionViewSectionedReloadDataSource<ProductSection>(
      configureCell: { [unowned self] (_, collectionView, indexPath, item) -> UICollectionViewCell in
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProductCell.self)
        cell.configure(with: item)
        cell.quantityChange
          .map { quantity in
            var item = item
            item.quantity = quantity
            return item
          }
          .bind(to: self.quantityChangeRelay)
          .disposed(by: cell.disposeBag)
        cell.bindEditModeChange(self.onEditModeChangeSubject.asObservable())
        cell.deleteProduct
          .map { item }
          .bind(to: self.deleteProductRelay)
          .disposed(by: cell.disposeBag)
        
        return cell
    })
    
    return datasource
  }
  
}
