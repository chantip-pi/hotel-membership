import 'package:flutter/material.dart';
import 'package:project/utils/format_string.dart';

class VoucherItem extends StatefulWidget {
  final Map<String, dynamic> voucherInfo;

  const VoucherItem({Key? key, required this.voucherInfo}) : super(key: key);

  @override
  _VoucherItemState createState() => _VoucherItemState();
}

class _VoucherItemState extends State<VoucherItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child:
                  ClipRRect(
                    child: Image.network(
                      widget.voucherInfo['imageUrl'], // Assuming 'image' is the URL of the voucher image
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                widget.voucherInfo['name'], // Assuming 'name' is the name of the voucher
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Valid Until ${FormatUtils.formatDate(widget.voucherInfo['dueDate'])}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    widget.voucherInfo['termsCondition'], 
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (newValue) {
                      setState(() {
                        _isChecked = newValue ?? false;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      'I agree to all the terms and conditions of usage.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ElevatedButton(
                onPressed: _isChecked
                    ? () {
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.all(10),
                ),
                child: Text(
                  "Redeem",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
