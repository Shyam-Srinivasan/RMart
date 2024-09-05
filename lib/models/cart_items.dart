class CartItem {
  double price;
  int quantity;

  CartItem({required this.price, required this.quantity});
}

class CartItems {
  static final CartItems _instance = CartItems._internal();

  factory CartItems() {
    return _instance;
  }

  CartItems._internal();

  Map<String, CartItem> cart_items_list = {
    'Sambar Rice': CartItem(price: 40.0, quantity: 0),
    'Idli': CartItem(price: 5.0, quantity: 0),
    'Pongal': CartItem(price: 30.0, quantity: 0),
    'Choola Poori': CartItem(price: 50.0, quantity: 0),
    'Chapati': CartItem(price: 15.0, quantity: 0),
    'Dosa': CartItem(price: 40.0, quantity: 0),
    'Veg Biriyani': CartItem(price: 50.0, quantity: 0),
    'Veg Noodles': CartItem(price: 50.0, quantity: 0),
    'Veg Rice': CartItem(price: 50.0, quantity: 0),
    'Veg Pasta': CartItem(price: 40.0, quantity: 0),
    'Egg Noodles': CartItem(price: 60.0, quantity: 0),
    'Egg Rice': CartItem(price: 80.0, quantity: 0),
    'Egg Pasta': CartItem(price: 60.0, quantity: 0),
    'Chips': CartItem(price: 20.0, quantity: 0),
    'Hide&Seek': CartItem(price: 20.0, quantity: 0),
    'Dark Fantasy': CartItem(price: 20.0, quantity: 0),
    'Cavins': CartItem(price: 40.0, quantity: 0),
    'Frooti': CartItem(price: 40.0, quantity: 0),
  };

  // Add categoryItems
  Map<String, List<Map<String, dynamic>>> categoryItems = {
    'BreakFast': [
      {'name': 'Pongal', 'price': 30.0, 'image': 'assets/img/Pongal.jpeg'},
      {'name': 'Idli', 'price': 5.0, 'image': 'assets/img/Idli.jpeg'},
      {'name': 'Dosa', 'price': 40.0, 'image': 'assets/img/Dosa.jpeg'},
    ],
    'Lunch': [
      {'name': 'Sambar Rice', 'price': 40.0, 'image': 'assets/img/SambarRice.jpeg'},
      {'name': 'Choola Poori', 'price': 50.0, 'image': 'assets/img/ChoolaPoori.jpeg'},
      {'name': 'Chapati', 'price': 15.0, 'image': 'assets/img/Chapati.jpeg'},
      {'name': 'Veg Biriyani', 'price': 50.0, 'image': 'assets/img/VegBiriyani.jpeg'},
      {'name': 'Veg Noodles', 'price': 50.0, 'image': 'assets/img/VegNoodles.jpeg'},
      {'name': 'Veg Rice', 'price': 50.0, 'image': 'assets/img/VegRice.jpeg'},
    ],
    'Snacks': [
      {'name': 'Chips', 'price': 20.0, 'image': 'assets/img/Chips.jpeg'},
      {'name': 'Hide&Seek', 'price': 20.0, 'image': 'assets/img/Hide&Seek.jpeg'},
      {'name': 'Dark Fantasy', 'price': 20.0, 'image': 'assets/img/DarkFantasy.jpeg'},
    ],
    'Beverages': [
      {'name': 'Cavins', 'price': 40.0, 'image': 'assets/img/Cavins.jpeg'},
      {'name': 'Frooti', 'price': 40.0, 'image': 'assets/img/Frooti.jpeg'},
    ],
  };
}