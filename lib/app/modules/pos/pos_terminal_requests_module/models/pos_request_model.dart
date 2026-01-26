import 'dart:convert';
import 'package:intl/intl.dart';

class PosRequestModel {
  final int id;
  final int posId;
  final String userName;
  final String accountType;
  final int quantity;
  final String address;
  final String city;
  final String state;
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final String purchaseType;
  final String reference;
  final int paymentStatus;
  final int status;
  final String? paymentData;
  final String createdAt;
  final String updatedAt;

  PosRequestModel({
    required this.id,
    required this.posId,
    required this.userName,
    required this.accountType,
    required this.quantity,
    required this.address,
    required this.city,
    required this.state,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.purchaseType,
    required this.reference,
    required this.paymentStatus,
    required this.status,
    this.paymentData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PosRequestModel.fromJson(Map<String, dynamic> json) {
    return PosRequestModel(
      id: json['id'] ?? 0,
      posId: json['pos_id'] ?? 0,
      userName: json['user_name'] ?? '',
      accountType: json['account_type'] ?? '',
      quantity: json['quantity'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      contactName: json['contact_name'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      purchaseType: json['purchase_type'] ?? '',
      reference: json['reference'] ?? '',
      paymentStatus: json['payment_status'] ?? 0,
      status: json['status'] ?? 0,
      paymentData: json['payment_data'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pos_id': posId,
      'user_name': userName,
      'account_type': accountType,
      'quantity': quantity,
      'address': address,
      'city': city,
      'state': state,
      'contact_name': contactName,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'purchase_type': purchaseType,
      'reference': reference,
      'payment_status': paymentStatus,
      'status': status,
      'payment_data': paymentData,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Getters for formatted data
  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  String get formattedTime {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  String get formattedPurchaseType {
    return purchaseType == 'outright' ? 'Outright Purchase' : 'Lease Purchase';
  }

  String get statusText {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  String get paymentStatusText {
    return paymentStatus == 1 ? 'Paid' : 'Unpaid';
  }

  // Get authorization URL from payment_data if exists
  String? get authorizationUrl {
    if (paymentData == null || paymentData!.isEmpty) return null;

    try {
      final decoded = json.decode(paymentData!);
      return decoded['data']?['authorization_url'];
    } catch (e) {
      return null;
    }
  }

  // Get payment reference from payment_data if exists
  String? get paymentReference {
    if (paymentData == null || paymentData!.isEmpty) return null;

    try {
      final decoded = json.decode(paymentData!);
      return decoded['data']?['reference'];
    } catch (e) {
      return null;
    }
  }

  // Format amount based on quantity (example: assuming 150k per terminal)
  String get formattedAmount {
    final amount = quantity * 150000; // Adjust this based on actual pricing
    final formatter = NumberFormat('#,##0', 'en_US');
    return '₦${formatter.format(amount)}.00';
  }

  String get formattedAmountPaid {
    if (paymentStatus == 1) {
      return formattedAmount;
    }
    // For now, if not paid, assume 0. logic can be enhanced
    return '₦0.00';
  }

  String get formattedAmountUnpaid {
    if (paymentStatus == 1) {
      return '₦0.00';
    }
    return formattedAmount;
  }
}
