// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum L10n {

  public enum Buttons {
    /// Add
    public static let add = L10n.tr("Localizable", "buttons.add")
    /// Checkout
    public static let checkout = L10n.tr("Localizable", "buttons.checkout")
    /// Done
    public static let done = L10n.tr("Localizable", "buttons.done")
    /// Edit
    public static let edit = L10n.tr("Localizable", "buttons.edit")
  }

  public enum Cart {
    /// User cart is empty
    public static let emptyCart = L10n.tr("Localizable", "cart.empty_cart")
    /// Summary
    public static let summary = L10n.tr("Localizable", "cart.summary")
    /// Cart
    public static let title = L10n.tr("Localizable", "cart.title")
  }

  public enum Checkout {
    /// Checkout
    public static let title = L10n.tr("Localizable", "checkout.title")
  }

  public enum Currency {
    /// UAH
    public static let uah = L10n.tr("Localizable", "currency.uah")
  }

  public enum Summary {
    /// (%ld quantity_text)
    public static func quantityText(_ p1: Int) -> String {
      return L10n.tr("Localizable", "summary.quantity_text", p1)
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
