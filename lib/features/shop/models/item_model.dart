class Item {
  final String name;
  final String image;

  const Item({
    required this.name,
    required this.image,
  });
}


final List<Item> itemsList = [
  const Item(name: 'Donatello', image: 'assets/images/high-heel.png'),
  const Item(name: 'Item 2', image: 'assets/images/shop-woman.png'),
  const Item(name: 'Hermes', image: 'assets/images/shop_bag.png'),
  const Item(name: 'Blue candy', image: 'assets/images/blue-shoe.png'),
];

final List<Item> shoeItemsList = [
  const Item(name: 'Brown tight', image: 'assets/images/brown-shoe.png'),
  const Item(name: 'Blue candy', image: 'assets/images/blue-shoe.png'),
  const Item(name: 'ZIZI', image: 'assets/images/zizi-shoe.png'),
  const Item(name: 'Donatello', image: 'assets/images/high-heel.png'),
];

final List<Item> shirtItemsList = [
  const Item(name: 'Pull and deer', image: 'assets/images/shirt-pull.png'),
  const Item(name: 'Gabriel', image: 'assets/images/shirt-gabriel.png'),
  const Item(name: 'Prada', image: 'assets/images/shirt-prada.png'),
  const Item(name: 'Dior', image: 'assets/images/shirt-dior.png'),
];


class OrderHistory {
  final String date;
  final String time;
  final String address;
  final String itemName;
  final String itemSubName;
  final String image;
  final String numOfItem;

  OrderHistory({
    required this.date, 
    required this.time, 
    required this.address, 
    required this.itemName,
    required this.itemSubName, 
    required this.image, 
    required this.numOfItem
  });
}


final List<OrderHistory> orderHistoryList = [
  OrderHistory(
    date: 'TODAY', 
    time: '12:10 AM', 
    address: '3517 W. Gray St. Utica, Pennsylvania 57867', 
    itemName: 'Hermes', 
    itemSubName: 'Antelope', 
    image: 'assets/images/shop_bag.png', 
    numOfItem: '1'
  ),
  OrderHistory(
    date: 'YESTERDAY', 
    time: '03:10 PM', 
    address: '6391 Elgin St. Celina, Delaware 10299', 
    itemName: 'Expand', 
    itemSubName: 'Safiyah', 
    image: 'assets/images/shirt-pull.png', 
    numOfItem: '1'
  ),
  OrderHistory(
    date: 'YESTERDAY', 
    time: '07:49 PM', 
    address: '3517 W. Gray St. Utica, Pennsylvania 57867', 
    itemName: 'Hush puppies', 
    itemSubName: 'Amory', 
    image: 'assets/images/blue-shoe.png', 
    numOfItem: '3'
  ),
  OrderHistory(
    date: 'YESTERDAY', 
    time: '03:12 AM', 
    address: '6391 Elgin St. Celina, Delaware 10299', 
    itemName: 'MILLE', 
    itemSubName: 'Cassia Dress Red', 
    image: 'assets/images/shirt-prada.png', 
    numOfItem: '2'
  ),
  OrderHistory(
    date: 'YESTERDAY', 
    time: '03:12 AM', 
    address: '6391 Elgin St. Celina, Delaware 10299', 
    itemName: 'MILLE', 
    itemSubName: 'Cassia Dress Red', 
    image: 'assets/images/shirt-prada.png', 
    numOfItem: '1'
  ),
  OrderHistory(
    date: 'YESTERDAY', 
    time: '03:12 AM', 
    address: '6391 Elgin St. Celina, Delaware 10299', 
    itemName: 'MILLE', 
    itemSubName: 'Cassia Dress Red', 
    image: 'assets/images/shirt-prada.png', 
    numOfItem: '1'
  ),
  OrderHistory(
    date: 'YESTERDAY', 
    time: '03:12 AM', 
    address: '6391 Elgin St. Celina, Delaware 10299', 
    itemName: 'MILLE', 
    itemSubName: 'Cassia Dress Red', 
    image: 'assets/images/shirt-prada.png', 
    numOfItem: '1'
  ),
  OrderHistory(
    date: 'YESTERDAY', 
    time: '03:12 AM', 
    address: '6391 Elgin St. Celina, Delaware 10299', 
    itemName: 'MILLE', 
    itemSubName: 'Cassia Dress Red', 
    image: 'assets/images/shirt-prada.png', 
    numOfItem: '1'
  ),
];