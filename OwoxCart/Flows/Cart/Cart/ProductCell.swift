//
//  ProductCell.swift
//  OwoxCart
//
//  Created by Stas Kirichok on 18-10-2018.
//  Copyright © 2018 Stas Kirichok. All rights reserved.
//

import Foundation
import Reusable
import UIKit
import ValueStepper
import Core
import Kingfisher
import SwiftGen
import RxSwift

class ProductCell: UICollectionViewCell, NibReusable {
  
  @IBOutlet private weak var deleteButton: UIButton!
  @IBOutlet private weak var pictureView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var oldPriceLabel: UILabel!
  @IBOutlet private weak var currentPriceLabel: UILabel!
  @IBOutlet private weak var quantityStepper: ValueStepper!
  @IBOutlet private weak var deleteButtonContainer: UIStackView!
  
  var quantityChange: Observable<Int> {
    return quantityChangeSubject.asObservable()
  }
  var deleteProduct: Observable<Void> {
    return deleteButton.rx.tap.asObservable()
  }
  
  private(set) var disposeBag = DisposeBag()
  private let quantityChangeSubject = PublishSubject<Int>()
  private let editModeChangeSubject = PublishSubject<Bool>()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    quantityStepper.maximumValue = Double.greatestFiniteMagnitude
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
  
  func configure(with inCartProduct: InCartProduct) {
    pictureView.kf.setImage(with: inCartProduct.product.image, placeholder: UIImage(asset: Asset.imagePlaceholder))
    titleLabel.text = inCartProduct.product.title
    if let oldPrice = inCartProduct.product.oldPrice, oldPrice > inCartProduct.product.price {
      let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strikethroughStyle: 2,
        NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
      let text = NSMutableAttributedString(string: "\(oldPrice) \(L10n.Currency.uah)", attributes: attributes)
      oldPriceLabel.attributedText = text
      oldPriceLabel.isHidden = false
    } else {
      oldPriceLabel.isHidden = true
    }
    currentPriceLabel.text = "\(inCartProduct.product.price) \(L10n.Currency.uah)"
    let quantity = Double(inCartProduct.quantity)
    if quantityStepper.value != quantity {
      quantityStepper.value = quantity
    }
  }
  
  func bindEditModeChange(_ observable: Observable<Bool>) {
    observable
      .map { !$0 }
      .bind(to: deleteButtonContainer.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  @IBAction private func didChangeProductQuantity(_ sender: Any) {
    quantityChangeSubject.onNext(Int(quantityStepper.value))
  }
  
}
