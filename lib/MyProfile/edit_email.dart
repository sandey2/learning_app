import 'package:flutter/material.dart';
import 'package:learning/app_colors.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  final _keyform = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the screen is disposed.
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Email'),
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
                          Icons.email_outlined,
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
                          controller: controllerEmail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required Email!';
                            } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                .hasMatch(value)) {
                              return 'Enter a valid email address!';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
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
                      // Save the new email
                      String updatedEmail = controllerEmail.text;
                      // Assuming you want to navigate back to the profile screen
                      Navigator.pop(context, updatedEmail);
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
