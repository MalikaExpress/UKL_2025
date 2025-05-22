import 'package:flutter/material.dart';
import 'package:movie_app/services/user_update_service.dart';
import 'package:movie_app/widgets/alert.dart';

class UpdateUserView extends StatefulWidget {
  const UpdateUserView({super.key});

  @override
  State<UpdateUserView> createState() => _UpdateUserViewState();
}

class _UpdateUserViewState extends State<UpdateUserView> {
  final UserUpdateService userUpdateService = UserUpdateService();
  final formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController(text: "1");
  final TextEditingController namaPelanggan = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController telepon = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    setState(() {
      isLoading = true;
    });

    final response = await userUpdateService.fetchUserProfile();

    if (response.status) {
      final data = response.data;
      setState(() {
        idController.text = data['id'].toString();
        namaPelanggan.text = data['nama_pelanggan'];
        gender.text = data['gender'];
        alamat.text = data['alamat'];
        telepon.text = data['telepon'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      AlertMessage().showAlert(context, response.message, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFfeda75), Color(0xFFfa7e1e), Color(0xFFd62976)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, size: 64, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  const Text(
                    "Update User",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Edit your profile information",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: idController,
                          decoration: InputDecoration(
                            labelText: "ID",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.numbers),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'ID harus diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: namaPelanggan,
                          decoration: InputDecoration(
                            labelText: "Nama Pelanggan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Nama pelanggan harus diisi'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: gender.text.isNotEmpty ? gender.text : null,
                          decoration: InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.wc),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'Laki-laki', child: Text('Laki-laki')),
                            DropdownMenuItem(
                                value: 'Perempuan', child: Text('Perempuan')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              gender.text = value!;
                            });
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Gender harus dipilih'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: alamat,
                          decoration: InputDecoration(
                            labelText: "Alamat",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.home_outlined),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Alamat harus diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: telepon,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Telepon",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Telepon harus diisi' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                var data = {
                                  "id": idController.text,
                                  "nama_pelanggan": namaPelanggan.text,
                                  "gender": gender.text,
                                  "alamat": alamat.text,
                                  "telepon": telepon.text,
                                };

                                var result =
                                    await userUpdateService.updateUser(data);

                                setState(() {
                                  isLoading = false;
                                });

                                if (result.status == true) {
                                  AlertMessage()
                                      .showAlert(context, result.message, true);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  AlertMessage().showAlert(
                                      context, result.message, false);
                                }
                              }
                            },
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Update",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
