import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/data_service.dart';
import 'package:manajemen_aset/utilis/api_config.dart';

class PengembalianAsetScreen extends StatefulWidget {
  final Map<String, dynamic> aset;

  const PengembalianAsetScreen({Key? key, required this.aset})
      : super(key: key);

  @override
  State<PengembalianAsetScreen> createState() => _PengembalianAsetScreenState();
}

class _PengembalianAsetScreenState extends State<PengembalianAsetScreen> {
  DataService dataService = DataService();
  final _formKey = GlobalKey<FormState>();
  final _peminjamController = TextEditingController();
  DateTime? _tanggalKembali;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengembalian Aset'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //Menambahkan Nama Peminjam
              SizedBox(height: 10),
              Text(
                "Nama Peminjam",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _peminjamController,
                decoration: InputDecoration(
                  hintText: 'Nama Peminjam',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Ubah warna border menjadi biru
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama peminjam tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              //Menambahkan Tanggal Kembali
              SizedBox(height: 10),
              Text(
                "Tanggal Pengembalian",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    hintText: _tanggalKembali != null
                        ? DateFormat('yyyy-MM-dd').format(_tanggalKembali!)
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.blue), // Ubah warna border menjadi biru
                    )),
                onTap: () => _selectDate(context, (DateTime? date) {
                  setState(() {
                    _tanggalKembali = date;
                  });
                }),
              ),
              const SizedBox(height: 16),

              // Tombol Pinjam
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      String asetId = widget.aset['_id']; // ID aset
                      String tanggalKembali =
                          DateFormat('yyyy-MM-dd').format(_tanggalKembali!);

                      // Panggil fungsi untuk menyimpan data pengembalian
                      var response = await dataService.updateId(
                          'tanggal_pengembalian',
                          tanggalKembali,
                          token,
                          appId,
                          project,
                          "peminjaman_aset",
                          asetId);

                      // Handle response
                      if (response != '[]') {
                        // Pengembalian berhasil
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Aset berhasil dikembalikan!')),
                        );

                        // Navigasi kembali ke halaman sebelumnya
                        Navigator.pop(context);
                      } else {
                        // Pengembalian gagal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Gagal mengembalikan aset.')),
                        );
                      }
                    } catch (e) {
                      // Tangani error
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terjadi error.')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  // Warna latar belakang
                  foregroundColor: Colors.white,
                  // Warna teks
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('KEMBALIKAN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(
      BuildContext context, Function(DateTime?) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    onDateSelected(picked);
  }
}
