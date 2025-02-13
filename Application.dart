import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Harvest Hub',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/profile.jpeg'),
            SizedBox(height: 20),
            Text(
              'Welcome to Harvest Hub!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Login / Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  User? signedUpUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Simulate login success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login Successful')),
                    );
                    // Navigate to Home Page after successful login
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(signedUpUser: signedUpUser),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text('Forgot Password?'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push<User>(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );

                  if (result != null) {
                    signedUpUser = result;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final User? signedUpUser;

  HomePage({this.signedUpUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'), // Replace with your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRoundButton(Icons.home, 'Home', context),
                    _buildRoundButton(Icons.search, 'Search', context, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage(locality: signedUpUser?.locality?? '')),
                      );
                    }),
                    _buildRoundButton(Icons.notifications, 'Notifications', context, onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationsPage()),
                      );
                    }),
                    _buildRoundButton(
                      Icons.person,
                      'Profile',
                      context,
                      onPressed: () {
                        if (signedUpUser!= null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(user: signedUpUser!),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No user data found')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, String label, BuildContext context, {VoidCallback? onPressed}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed?? () {},
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

class NotificationsPage extends StatelessWidget {
  final List<String> farmingTips = [
    'Rotate crops to improve soil health.',
    'Use organic fertilizers to enrich the soil.',
    'Implement drip irrigation to save water.',
    'Practice integrated pest management.',
    'Maintain farm equipment regularly.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harvest Hub'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Emergency Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('No emergency alerts as of now'),
              SizedBox(height: 20),
              Text(
                'General Tips',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              for (String tip in farmingTips)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('• $tip'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showOtpField = false;
  bool _showPasswordFields = false;

  void _sendOTP() {
    setState(() {
      _showOtpField = true;
    });
  }

  void _verifyOTP() {
    setState(() {
      _showPasswordFields = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendOTP,
              child: Text('Send OTP'),
            ),
            if (_showOtpField) ...[
              TextField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'OTP'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: Text('Verify OTP'),
              ),
            ],
            if (_showPasswordFields) ...[
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_newPasswordController.text == _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password Reset Successful')),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                },
                child: Text('Reset Password'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  final String locality;

  SearchPage({required this.locality});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final List<String> states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan',
    'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh',
    'Uttarakhand', 'West Bengal', 'Andaman and Nicobar Islands', 'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu', 'Lakshadweep', 'Delhi',
    'Puducherry', 'Ladakh', 'Jammu and Kashmir'
  ];

  final List<String> crops = [
    'Amaranth leaves', 'Amla', 'Ash gourd', 'Baby corn', 'Banana flower', 
    'Beetroot', 'Bell Pepper (Capsicum)', 'Bitter gourd', 'Bottlegourd', 
    'Butter beans', 'Broad beans (Fava beans, lima beans)', 'Cabbage', 
    'Carrot', 'Cauliflower', 'Cluster beans', 'Coconut (fresh)', 
    'Coriander leaves (Cilantro)', 'Corn', 'Cucumber', 'Curry leaves',
    'Dill leaves', 'Drumsticks', 'Eggplant (Brinjal or Aubergine)', 
    'Brinjal ( Big )', 'Elephant Yam', 'Fenugreek leaves', 
    'French Beans (Green beans)', 'Garlic', 'Ginger', 'Green chili', 
    'Green peas', 'Ivy gourd', 'Lemon (Lime)', 'Mango', 'Mint leaves', 
    'Mushroom', 'Mustard leaves', 'Okra (Ladies finger)', 'Onion Big', 
    'Onion Small', 'Potato', 'Pumpkin', 'Radish(Daikon)', 'Ridge gourd', 
    'Snake gourd', 'Sorrel leaves', 'Spinach', 'Sweet potato', 'Tomato',
  ];

  final Map<String, List<int>> cropPrices = {
    'Amaranth leaves': [10, 14], 'Amla': [55, 70], 'Ash gourd': [20, 30], 
    'Baby corn': [60, 70], 'Banana flower': [15, 25], 'Beetroot': [30, 40], 
    'Bell Pepper (Capsicum)': [40, 55], 'Bitter gourd': [30, 40], 
    'Bottlegourd': [30, 40], 'Butter beans': [45, 55],
    'Broad beans (Fava beans, lima beans)': [55, 70], 'Cabbage': [30, 40], 
    'Carrot': [35, 50], 'Cauliflower': [20, 30], 'Cluster beans': [40, 50], 
    'Coconut (fresh)': [30, 45], 'Coriander leaves (Cilantro)': [10, 20], 
    'Corn': [30, 40], 'Cucumber': [25, 35], 'Curry leaves': [30, 38],
    'Dill leaves': [10, 15], 'Drumsticks': [70, 85], 
    'Eggplant (Brinjal or Aubergine)': [30, 40], 'Brinjal ( Big )': [30, 40], 
    'Elephant Yam': [35, 45], 'Fenugreek leaves': [10, 15], 
    'French Beans (Green beans)': [115, 130], 'Garlic': [210, 240], 
    'Ginger': [120, 135], 'Green chili': [55, 70], 'Green peas': [35, 50], 
    'Ivy gourd': [25, 35], 'Lemon (Lime)': [90, 110], 'Mango': [100, 140], 
    'Mint leaves': [10, 20], 'Mushroom': [75, 90], 'Mustard leaves': [10, 20], 
    'Okra (Ladies finger)': [35, 50], 'Onion Big': [40, 50],
    'Onion Small': [55, 65], 'Potato': [30, 45], 'Pumpkin': [25, 35], 
    'Radish(Daikon)': [35, 50], 'Ridge gourd': [30, 40], 
    'Snake gourd': [30, 40], 'Sorrel leaves': [15, 20], 'Spinach': [20, 30], 
    'Sweet potato': [30, 45], 'Tomato': [45, 60],
  };

  String? _selectedState;
  String? _selectedCrop;
  int? _selectedPrice;
void _fetchCropPrice() {
    if (_selectedCrop != null) {
      final priceRange = cropPrices[_selectedCrop]!;
      setState(() {
        _selectedPrice = priceRange[0] + (priceRange[1] - priceRange[0]) ~/ 2;  // Or use any random or fixed value within the range
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text('Choose State', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedState,
              hint: Text('Select a state'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedState = newValue;
                  _updatePrice();
                });
              },
              items: states.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Choose Crop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedCrop,
              hint: Text('Select a crop'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCrop = newValue;
                  _updatePrice();
                });
              },
              items: crops.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
 ElevatedButton(
              onPressed: _fetchCropPrice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Fetch Crop Price'),
            ),
            SizedBox(height: 20),
            if (_selectedPrice != null)
              Text(
                'Price of $_selectedCrop in $_selectedState is $_selectedPrice per kg',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  void _updatePrice() {
    if (_selectedState != null && _selectedCrop != null) {
      final priceRange = cropPrices[_selectedCrop]!;
      final price = priceRange[0] + (priceRange[1] - priceRange[0]) * _getStateIndex(_selectedState!) ~/ (states.length - 1);
      setState(() {
        _selectedPrice = price;
      });
    } else {
      setState(() {
        _selectedPrice = null;
      });
    }
  }

  int _getStateIndex(String state) {
    return states.indexOf(state);
  }
}


class User {
  final String name;
  final String phoneNumber;
  final String locality;

  User({required this.name, required this.phoneNumber, required this.locality});
}

class SignUpPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _localityController,
                decoration: InputDecoration(labelText: 'Locality'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your locality';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newUser = User(
                      name: _nameController.text,
                      phoneNumber: _phoneController.text,
                      locality: _localityController.text,
                    );
                    Navigator.pop(context, newUser);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/profile2.jpeg'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                user.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(user.phoneNumber),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text(user.locality),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
