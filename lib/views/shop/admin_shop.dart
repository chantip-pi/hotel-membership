import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/theme.dart';
import 'package:project/utils/format_string.dart';

class VoucherListPage extends StatefulWidget {
  @override
  _VoucherListPageState createState() => _VoucherListPageState();
}

class _VoucherListPageState extends State<VoucherListPage> {
  final VoucherService _voucherService = VoucherService();
  final TextEditingController _voucherNameController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _voucherTypeController = TextEditingController();
  final TextEditingController _termsConditionController = TextEditingController();
  final TextEditingController _discountPercentageController = TextEditingController();
  final TextEditingController _cashValueController = TextEditingController();
  final TextEditingController _giftItemController = TextEditingController();

  String selectedVoucherType = 'Discount'; // Default to Discount

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Show dialog to add a voucher
              _showAddVoucherDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _voucherService.getVoucherStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No vouchers available.');
          } else {
            var vouchers = snapshot.data!.docs.where((doc) => doc['onShop'] == true).toList();
            return ListView.builder(
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                var voucher = vouchers[index];
                return ListTile(
                  title: Text(voucher['name']),
                  // Add more details if needed
                   subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Points: ${voucher['points']}'),
                      Text('Due Date: ${(FormatUtils.formatDueDate(voucher['dueDate']))}'),
                      Text('Voucher Type: ${voucher['voucherType']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Delete the voucher
                      _voucherService.deleteVoucher(voucher.id);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to show an AlertDialog for adding a voucher
  void _showAddVoucherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Voucher'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _voucherNameController,
                      decoration: InputDecoration(labelText: 'Voucher Name'),
                    ),
                    TextField(
                      controller: _pointsController,
                      decoration: InputDecoration(labelText: 'Points'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _dueDateController,
                      decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedVoucherType,
                      items: ['Discount', 'Cash', 'Gift'].map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedVoucherType = value!;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Voucher Type'),
                    ),
                    TextField(
                      controller: _termsConditionController,
                      decoration: InputDecoration(labelText: 'Terms and Conditions'),
                    ),
                    if (selectedVoucherType == 'Discount')
                      TextField(
                        controller: _discountPercentageController,
                        decoration: InputDecoration(labelText: 'Discount Percentage'),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    if (selectedVoucherType == 'Cash')
                      TextField(
                        controller: _cashValueController,
                        decoration: InputDecoration(labelText: 'Cash Value'),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    if (selectedVoucherType == 'Gift')
                      TextField(
                        controller: _giftItemController,
                        decoration: InputDecoration(labelText: 'Gift Item'),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Add a voucher with the entered details
                    _voucherService.addVoucher(
                      name: _voucherNameController.text,
                      onShop: true,
                      timestamp: Timestamp.now(),
                      points: int.tryParse(_pointsController.text) ?? 0,
                      dueDate: Timestamp.fromDate(DateTime.parse(_dueDateController.text)),
                      voucherType: selectedVoucherType,
                      termsCondition: _termsConditionController.text,
                      discountPercentage: selectedVoucherType == 'Discount'
                          ? double.tryParse(_discountPercentageController.text)
                          : null,
                      cashValue: selectedVoucherType == 'Cash'
                          ? double.tryParse(_cashValueController.text)
                          : null,
                      giftItem: selectedVoucherType == 'Gift' ? _giftItemController.text : null,
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _voucherNameController.dispose();
    _pointsController.dispose();
    _dueDateController.dispose();
    _voucherTypeController.dispose();
    _termsConditionController.dispose();
    _discountPercentageController.dispose();
    _cashValueController.dispose();
    _giftItemController.dispose();
    super.dispose();
  }
}
