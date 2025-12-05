import 'package:get/get.dart';

class VirtualCardTransactionsController extends GetxController {
  final transactions = <Map<String, dynamic>>[
    {
      'icon': 'Shopping',
      'title': 'Shopping at Nike Store',
      'date': 'Oct 08, 2024 09:00 PM',
      'amount': '-\$200.00',
      'isDebit': true,
    },
    {
      'icon': 'Card',
      'title': 'Top up',
      'date': 'Oct 08, 2024 09:00 PM',
      'amount': '+\$100.00',
      'isDebit': false,
    },
    {
      'icon': 'Shopping',
      'title': 'Shopping at Nike Store',
      'date': 'Oct 08, 2024 09:00 PM',
      'amount': '-\$200.00',
      'isDebit': true,
    },
    {
      'icon': 'Card',
      'title': 'Top up',
      'date': 'Oct 08, 2024 09:00 PM',
      'amount': '+\$100.00',
      'isDebit': false,
    },
  ].obs;
}
