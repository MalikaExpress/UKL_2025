import 'dart:io' show File;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/services/user.dart';
import 'package:movie_app/widgets/alert.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  final TextEditingController namaNasabah = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController telepon = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  File? _imageFile;
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  String? gender;
  final List<String> genderOptions = ['Laki-laki', 'Perempuan'];

  bool _isPasswordVisible = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        if (!kIsWeb) {
          _imageFile = File(pickedFile.path);
        }
      });
    }
  }

  Widget imagePreview() {
    if (_pickedFile == null)
      return const Text(
        "Belum ada gambar dipilih",
        style: TextStyle(color: Colors.white70),
      );

    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: _pickedFile!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  Image.memory(snapshot.data!, height: 150, fit: BoxFit.cover),
            );
          }
          return const CircularProgressIndicator();
        },
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
      );
    }
  }

  InputDecoration inputDecoration({required String label, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      errorStyle: const TextStyle(color: Colors.yellowAccent),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      const Color(0xFF833ab4),
      const Color(0xFFfd1d1d),
      const Color(0xFFfcb045)
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Mandira',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: 'Segoe UI',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Nama Nasabah
                  TextFormField(
                    controller: namaNasabah,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration(label: 'Nama Nasabah'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    value: gender,
                    items: genderOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        gender = val;
                      });
                    },
                    decoration: inputDecoration(label: 'Gender'),
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),

                  const SizedBox(height: 16),

                  // Alamat
                  TextFormField(
                    controller: alamat,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration(label: 'Alamat'),
                    maxLines: 2,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Telepon
                  TextFormField(
                    controller: telepon,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration(label: 'Telepon'),
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Foto & nama file
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          elevation: 0,
                        ),
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: const Text(
                          "Pilih Foto",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          style: const TextStyle(color: Colors.white70),
                          decoration: inputDecoration(label: 'Nama File Foto'),
                          controller: TextEditingController(
                            text: _pickedFile?.name ?? '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Image preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.white.withOpacity(0.15),
                      alignment: Alignment.center,
                      child: imagePreview(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Username
                  TextFormField(
                    controller: username,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration(label: 'Username'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password with visibility toggle
                  TextFormField(
                    controller: password,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration(
                      label: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 32),

                  // Register button with gradient
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors.last.withOpacity(0.6),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var data = {
                            "nama_nasabah": namaNasabah.text,
                            "gender": gender ?? "",
                            "alamat": alamat.text,
                            "telepon": telepon.text,
                            "username": username.text,
                            "password": password.text,
                          };

                          print('Register data: $data');
                          print('File selected: ${_pickedFile?.path}');

                          var result =
                              await user.registerUser(data, file: _pickedFile);

                          if (result.status == true) {
                            namaNasabah.clear();
                            alamat.clear();
                            telepon.clear();
                            username.clear();
                            password.clear();
                            setState(() {
                              gender = null;
                              _imageFile = null;
                              _pickedFile = null;
                              _isPasswordVisible = false;
                            });

                            AlertMessage()
                                .showAlert(context, result.message, true);
                          } else {
                            AlertMessage()
                                .showAlert(context, result.message, false);
                          }
                        }
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
