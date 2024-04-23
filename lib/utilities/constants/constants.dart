import 'dart:io';

class Constant {
  Constant._();
  static final String baseUrlPath =
      Platform.isAndroid ? "http://10.0.2.2:3000" : "http://localhost:3000";
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordRegex =
      r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).*$';
  static const String phoneRegex = r'^0\d{9}$';
  static const String nameRegex = r'^[a-zA-Z ]+$';

  static const String _baseSystemIconAssetPath = "assets/icons/default";
  static const Map<String, String> defaultLightIcons = {
    "tag": "$_baseSystemIconAssetPath/light/tags.svg",
    "edit": "$_baseSystemIconAssetPath/light/pen-fancy.svg",
    "repaid": "$_baseSystemIconAssetPath/light/expense.svg",
  };

  static const Map<String, String> defaultRegularIcons = {
    "tag": "$_baseSystemIconAssetPath/regular/tags.svg",
    "uncheck": "$_baseSystemIconAssetPath/regular/uncheck-circle.svg",
    "check": "$_baseSystemIconAssetPath/regular/check-circle.svg",
  };

  static const Map<String, String> defaultBoldIcons = {
    "tag": "$_baseSystemIconAssetPath/bold/tags.svg",
    "uncheck": "$_baseSystemIconAssetPath/bold/uncheck.svg",
  };

  static const List<String> categoryIcons = [
    "assets/icons/categories/bolt.svg",
    "assets/icons/categories/books.svg",
    "assets/icons/categories/call.svg",
    "assets/icons/categories/car-mechanic.svg",
    "assets/icons/categories/car-side-bolt.svg",
    "assets/icons/categories/car-side.svg",
    "assets/icons/categories/child-head.svg",
    "assets/icons/categories/cosmetic.svg",
    "assets/icons/categories/coupon.svg",
    "assets/icons/categories/earth.svg",
    "assets/icons/categories/food1.svg",
    "assets/icons/categories/food2.svg",
    "assets/icons/categories/fuel.svg",
    "assets/icons/categories/game.svg",
    "assets/icons/categories/heart.svg",
    "assets/icons/categories/home.svg",
    "assets/icons/categories/hospital.svg",
    "assets/icons/categories/house-window.svg",
    "assets/icons/categories/kiss-wink-heart.svg",
    "assets/icons/categories/money-check.svg",
    "assets/icons/categories/paw.svg",
    "assets/icons/categories/person.svg",
    "assets/icons/categories/pets.svg",
    "assets/icons/categories/piggy-bank.svg",
    "assets/icons/categories/plane-alt.svg",
    "assets/icons/categories/shopping_cart.svg",
    "assets/icons/categories/shopping.svg",
    "assets/icons/categories/stock.svg",
    "assets/icons/categories/student-alt.svg",
    "assets/icons/categories/ticket.svg",
    "assets/icons/categories/wallet.svg",
    "assets/icons/categories/work.svg",
  ];

  static int defaultNonePropertyColor = 0xff999999;

  static List<int> colors = [
    0xFFF06292,
    0xFFE57373,
    0xFFBA68C8,
    0xFF9575CD,
    0xFF7986CB,
    0xFF64B5F6,
    0xFF4FC3F7,
    0xFF4DD0E1,
    0xFF4DB6AC,
    0xFF81C784,
    0xFFAED581,
    0xFFFF8A65,
    0xFFD4E157,
    0xFFFFD54F,
    0xFFFFB74D,
    0xFFA1887F,
    0xFF90A4AE,
  ];
}
