// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginButton => 'Login';

  @override
  String get exit => 'Exit';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'Follow System';

  @override
  String get cancel => 'Cancel';

  @override
  String get unknownError => 'An unexpected error occurred.';

  @override
  String get systemTitle => 'Topedindo Fiscal POS';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginError => 'Invalid username or password!';

  @override
  String get loginSuccess => 'Welcome!';

  @override
  String get password => 'Password';

  @override
  String get requiredLoginFields => 'Please enter a username';

  @override
  String get requiredPasswordFields => 'Please enter a password';

  @override
  String get logoutConfirmText => 'Do you really want to log out?';

  @override
  String get homeTitle => 'Home';

  @override
  String get checkoutTitle => 'Cart';

  @override
  String get checkoutError => 'An error occurred while finalizing the order.';

  @override
  String get checkoutSuccess => 'Order completed successfully!';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get paymentMethod => 'Payment Methods';

  @override
  String get addPaymentMethod => 'Add payment method';

  @override
  String get value => 'Value';

  @override
  String get insertValue => 'Enter the value';

  @override
  String get valueExceedsTotal => 'The entered value exceeds the total';

  @override
  String get totalPaid => 'Total paid';

  @override
  String get change => 'Change';

  @override
  String get totalFault => 'Remaining amount';

  @override
  String get finalizeSale => 'Finalize Sale';

  @override
  String get emptyCart => 'The cart is empty';

  @override
  String get productsTitle => 'Products';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get confirmDeleteProduct =>
      'Are you sure you want to delete this product?';

  @override
  String get productSaved => 'Product saved successfully!';

  @override
  String get productDeleted => 'Product deleted successfully!';

  @override
  String get productError => 'An error occurred while saving the product.';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get settingsTitle => 'Settings';
}
