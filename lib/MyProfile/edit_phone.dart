import 'package:flutter/material.dart';
import 'package:learning/app_colors.dart';

class EditPhone extends StatefulWidget {
  const EditPhone({super.key});

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  final _keyform = GlobalKey<FormState>();
  final TextEditingController controllerPhone = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the screen is disposed.
    controllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Phone Number'),
        ),
        body: Form(
          key: _keyform,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(180),
                          ),
                        ),
                        child: const Icon(
                          Icons.phone_in_talk,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      child: Center(
                        child: TextFormField(
                          controller: controllerPhone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required Phone Number!';
                            } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                              return 'Enter a valid phone number!';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              size: 32,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (_keyform.currentState!.validate()) {
                      // Save the new phone number
                      String updatedPhone = controllerPhone.text;
                      // Assuming you want to navigate back to the profile screen
                      Navigator.pop(context, updatedPhone);
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppColors.icons_color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
