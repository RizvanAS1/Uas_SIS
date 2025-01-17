import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/utilis/api_config.dart';

import '../data_service.dart';

class PeminjamanAsetScreen extends StatefulWidget {
  final Map<String, dynamic> aset;

  const PeminjamanAsetScreen({Key? key, required this.aset}) : super(key: key);

  @override
  State<PeminjamanAsetScreen> createState() => _PeminjamanAsetScreenState();
}

class _PeminjamanAsetScreenState extends State<PeminjamanAsetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _setujuSyaratKetentuan = false;
  final _peminjamController = TextEditingController();
  DateTime? _tanggalPinjam;
  DateTime? _tanggalKembali;

  DataService dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman Aset'),
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

              //Menambahkan Tanggal Pinjam
              SizedBox(height: 10),
              Text(
                "Tanggal Pinjam",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    hintText: _tanggalPinjam != null
                        ? DateFormat('yyyy-MM-dd').format(_tanggalPinjam!)
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
                    _tanggalPinjam = date;
                  });
                }),
              ),
              const SizedBox(height: 16),

              //Menambahkan Tanggal Kembali
              SizedBox(height: 10),
              Text(
                "Tanggal Kembali",
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

              // Checkbox persetujuan
              Row(
                children: [
                  Checkbox(
                    value: _setujuSyaratKetentuan,
                    onChanged: (value) {
                      setState(() {
                        _setujuSyaratKetentuan = value!;
                      });
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Saya setuju dengan ',
                          style: TextStyle(color: Colors.black), // Style untuk teks biasa
                        ),
                        TextSpan(
                          text: 'syarat dan ketentuan',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Tampilkan dialog syarat dan ketentuan
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Syarat dan Ketentuan'),
                                  content: Text(widget.aset['syarat_ketentuan']), // Ganti dengan data syarat dan ketentuan aset
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),


              // Tombol Pinjam
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_setujuSyaratKetentuan) {
                      String asetid = widget.aset['_id']; // ID aset
                      String namaPeminjam = _peminjamController.text;
                      String tanggalPinjam = DateFormat('yyyy-MM-dd').format(_tanggalPinjam!);
                      String tanggalKembali = DateFormat('yyyy-MM-dd').format(_tanggalKembali!);
                      String tanggalPengembalian = '-';

                      // Panggil fungsi insertPeminjamanAset
                      var response = await dataService.insertPeminjamanAset(
                        appId,
                        asetid,
                        namaPeminjam,
                        tanggalPinjam,
                        tanggalKembali,
                        tanggalPengembalian,
                      );

                      // Handle response
                      if (response != '[]') {
                        // Data berhasil disimpan
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Peminjaman berhasil!')),
                        );
                        // Navigasi kembali ke halaman sebelumnya
                        Navigator.pop(context);
                      } else {
                        // Terjadi error saat menyimpan data
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal meminjam aset.')),
                        );
                      }
                    } else {
                      // Tampilkan pesan error jika checkbox belum dicentang
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Anda harus menyetujui syarat dan ketentuan')),
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
                child: const Text('PINJAM'),
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
