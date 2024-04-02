import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:project/services/image_storage.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/utils/theme.dart';

class AddVoucher extends StatefulWidget {
  const AddVoucher({super.key});

  @override
  State<AddVoucher> createState() => _AddVoucherState();
}

class _AddVoucherState extends State<AddVoucher> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _voucherNameController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _voucherTypeController = TextEditingController();
  final TextEditingController _termsConditionController =
      TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _cashValueController = TextEditingController();
  final TextEditingController _giftItemController = TextEditingController();

  String selectedVoucherType = 'Discount';
  VoucherService _voucherService = VoucherService();

  final FirebaseImageUtils _firebaseImageUtils = FirebaseImageUtils();
  String imageUrl = '';

 Future<void> _selectImageSourceDialog() async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Image Source', style: TextStyle(color: Colors.black)),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              ListTile(
                title: const Text('Gallery', style: TextStyle(color: Colors.black)),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    imageUrl = await _firebaseImageUtils.uploadImageFromGallery('voucher_image');
                  } catch (e) {
                    print('Error uploading image from gallery: $e');
                  }
                },
              ),
              ListTile(
                title: const Text('Camera', style: TextStyle(color: Colors.black)),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    imageUrl = await _firebaseImageUtils.uploadImageFromCamera('voucher_image');
                  } catch (e) {
                    print('Error capturing image from camera: $e');
                  }
                },
              ),
            ],
          ),
        ),
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

  late DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _selectedDate,
      lastDate: DateTime(2104),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.primaryColor, 
            hintColor: AppTheme.secondaryColor, 
            colorScheme: const ColorScheme.light(
                primary: AppTheme.primaryColor), 
            buttonTheme: const ButtonThemeData(
                textTheme:
                    ButtonTextTheme.primary), 
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dueDateController.text =
            DateFormat('dd MMM yyyy').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Voucher",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (imageUrl.isNotEmpty) {
              _firebaseImageUtils.deletePictureByUrl(imageUrl);
            }
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (imageUrl.isEmpty)
              Image.asset(
                'assets/images/default-voucher-image.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fill,
              ),
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _selectImageSourceDialog();
                        setState(() {});
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppTheme.secondaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Select Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    _buildVoucherNameTextField(),
                    _builPointsTextField(),
                    _buildDueDateTextField(),
                    _buildVoucherType(),
                    _buildVoucherValue(),
                    _buildTermsTextField(),
                    _buildButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _voucherNameController,
        cursorColor: Colors.black,
        maxLength: 40,
        decoration: const InputDecoration(
          labelText: 'Voucher Name',
          labelStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
              width: 2.0,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter voucher name.';
          }
          return null;
        },
      ),
    );
  }

  Widget _builPointsTextField() {
    final RegExp numberRegex = RegExp(r'^[0-9]+$');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _pointsController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Points',
            labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a number.';
            }
            if (!numberRegex.hasMatch(value)) {
              return 'Invalid input. Please enter a number.';
            }
            return null;
          }),
    );
  }

  Widget _buildDueDateTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _dueDateController,
          cursorColor: Colors.black,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: const InputDecoration(
            labelText: 'Valid Until',
            labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            suffixIcon: Icon(Icons.calendar_today),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a date.';
            }
            return null;
          }),
    );
  }

  Widget _buildTermsTextField() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: TextFormField(
      controller: _termsConditionController,
      cursorColor: Colors.black,
      maxLines: 10,
      maxLength: 1500,
      decoration: const InputDecoration(
         hintText: 'Type terms & conditions as follows:\n-first term\n-second term...',
        labelText: 'Terms & Condition',
        labelStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 20, 12, 12),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2.0,
          ),
        ),
      ),
      onFieldSubmitted: (_) {
        _insertNewLine();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter terms & conditions.';
        }
        return null;
      },
    ),
  );
}

void _insertNewLine() {
  final text = _termsConditionController.text;
  final newText = text + '-';
  _termsConditionController.value = _termsConditionController.value.copyWith(
    text: newText,
    selection: TextSelection.collapsed(offset: newText.length),
  );
}


  Widget _buildVoucherType() {
  return DropdownButtonFormField<String>(
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
    decoration: const InputDecoration(
      labelText: 'Voucher Type',
      labelStyle: TextStyle(
        color: AppTheme.primaryColor,
      ),
      filled: true,
      fillColor: Colors.white,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.primaryColor,
          width: 2.0,
        ),
      ),
    ),
  );
}


  Widget _buildVoucherValue() {
    final RegExp numberRegex = RegExp(r'^[0-9]+$');

    if (selectedVoucherType == 'Cash') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
            controller: _cashValueController,
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cash Amount',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number.';
              }
              if (!numberRegex.hasMatch(value)) {
                return 'Invalid input. Please enter a number.';
              }
              return null;
            }),
      );
    }
    if (selectedVoucherType == 'Gift') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
            controller: _giftItemController,
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              labelText: 'Gift Description',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter gift description.';
              }
              return null;
            }),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
            controller: _discountPercentageController,
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Discount Percentage',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number.';
              }
              if (!numberRegex.hasMatch(value)) {
                return 'Invalid input. Please enter a number.';
              }
              return null;
            }),
      );
    }
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(56),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    _voucherService.addVoucher(
                      name: _voucherNameController.text,
                      onShop: true,
                      timestamp: Timestamp.now(),
                      points: int.tryParse(_pointsController.text) ?? 0,
                      dueDate: Timestamp.fromDate(_selectedDate),
                      voucherType: selectedVoucherType,
                      termsCondition: _termsConditionController.text,
                      discountPercentage: selectedVoucherType == 'Discount'
                          ? double.tryParse(_discountPercentageController.text)
                          : null,
                      cashValue: selectedVoucherType == 'Cash'
                          ? double.tryParse(_cashValueController.text)
                          : null,
                      giftItem: selectedVoucherType == 'Gift'
                          ? _giftItemController.text
                          : null,
                     imageUrl: imageUrl.isNotEmpty
                                ? imageUrl
                                : "https://firebasestorage.googleapis.com/v0/b/hotel-membership-2b18b.appspot.com/o/voucher_image%2Fdefault-voucher-image.png?alt=media&token=dc6c37c3-d22b-4597-8486-dfdb7443ffae",

                    );
                    Navigator.pop(context);
                  } catch (e) {
                    print('Adding Voucher failed: $e');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please fix the errors and fill out all the fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Center(
                child: Text(
                  'Add',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
