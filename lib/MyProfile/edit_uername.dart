import 'package:flutter/material.dart';
import 'package:learning/app_colors.dart';

class EditUsername extends StatefulWidget {
  const EditUsername({super.key});

  @override
  State<EditUsername> createState() => _EditUsernameState();
}

class _EditUsernameState extends State<EditUsername> {
  final _keyform = GlobalKey<FormState>();
  final TextEditingController controllerUsername = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the screen is disposed.
    controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Username'),
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
                          Icons.person_outline,
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
                          controller: controllerUsername,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required Username!';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            prefixIcon: Icon(
                              Icons.person,
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
                      // Save the new username
                      String updatedUsername = controllerUsername.text;
                      // Assuming you want to navigate back to the profile screen
                      Navigator.pop(context, updatedUsername);
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
