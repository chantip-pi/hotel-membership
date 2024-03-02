import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/services/user_service.dart';
import 'package:project/theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController citizenIDController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  String selectedGender = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedGender = 'Male';
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _signUp(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user?.uid ?? "";

    UserService().addUserDetails(
        uid: uid,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: selectedGender.trim(),
        citizenID: citizenIDController.text.trim(),
        address: _addressController.text.trim(),
        birthdate: _selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2104),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.primaryColor, // Head background
            hintColor: AppTheme.secondaryColor, // Text on head
            colorScheme: const ColorScheme.light(
                primary: AppTheme.primaryColor), // Text on days
            buttonTheme: const ButtonThemeData(
                textTheme:
                    ButtonTextTheme.primary), // OK/Cancel button text color
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdateController.text =
            DateFormat('dd MMM yyyy').format(_selectedDate);
      });
    }
  }

  final RegExp numberRegex = RegExp(r'^[0-9]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSignUpText(),
          _buildInfoContainer(),
        ],
      ),
    );
  }

  Widget _buildSignUpText() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 46, top: 46),
        child: Text(
          "Sign up",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(children: [
                _buildNameTextField(),
                _buildSurnameTextField(),
                _buildEmailTextField(),
                _buildPasswordTextField(),
                _buildconfirmPasswordTextField(),
                _buildPhoneTextField(),
                _buildBirthdateTextField(),
                _buildSelectGender(),
                _buildCitizenIDTextField(),
                _buildAddressTextField(),
                _buildSignUpButton(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
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
              return 'Please enter your name.';
            }
            return null;
          }),
    );
  }

  Widget _buildSurnameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _surnameController,
          decoration: const InputDecoration(
            labelText: 'Surname',
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
              return 'Please enter your surname.';
            }
            return null;
          }),
    );
  }

  Widget _buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email Address',
          hintText: 'example@gmail.com',
          hintStyle: TextStyle(color: Colors.grey),
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
            return 'Please enter an email address.';
          }
          if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
              .hasMatch(value)) {
            return 'Please enter a valid email address.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(fontSize: 18, color: Colors.black),
          hintText: 'must be 8 characters',
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: _togglePasswordVisibility,
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
              width: 2.0,
            ),
          ),
        ),
        obscureText: _obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password.';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildconfirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: _confirmPasswordController,
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
              width: 2.0,
            ),
          ),
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password.';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
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
              return 'Please enter your phone number.';
            }
            if (!numberRegex.hasMatch(value)) {
              return 'Invalid input. Please enter a valid number.';
            }
            return null;
          }),
    );
  }

  Widget _buildBirthdateTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _birthdateController,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: const InputDecoration(
            labelText: 'Birthdate',
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
              return 'Please enter your birthdate.';
            }
            return null;
          }),
    );
  }

  Widget _buildGenderButton(String gender) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedGender = gender;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          selectedGender == gender ? AppTheme.primaryColor : Colors.grey,
        ),
      ),
      child: Text(
        gender,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSelectGender() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildGenderButton('Male'),
          _buildGenderButton('Female'),
          _buildGenderButton('Other'),
        ],
      ),
    );
  }

  Widget _buildCitizenIDTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: citizenIDController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Citizen ID',
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
            return 'Please enter your citizen ID.';
          }
          if (!numberRegex.hasMatch(value)) {
            return 'Invalid input. Please enter a valid number.';
          }
          if (value.length != 13) {
            return 'Invalid citizen ID.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAddressTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: _addressController,
        maxLines: 4,
        maxLength: 300,
        decoration: const InputDecoration(
          labelText: 'Address',
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your address.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
                    await _signUp(_emailController.text.trim(),
                        _passwordController.text.trim());
                    Navigator.pop(context);
                  } catch (e) {
                    print('Signup failed: $e');
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
                  'Sign up',
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
