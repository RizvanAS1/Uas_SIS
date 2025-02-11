import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_service.dart';

class PenjadwalanPerawatanScreen extends StatefulWidget {
  final String assetId;

  const PenjadwalanPerawatanScreen({super.key, required this.assetId});

  @override
  State<PenjadwalanPerawatanScreen> createState() =>
      _PenjadwalanPerawatanScreenState();
}

class _PenjadwalanPerawatanScreenState
    extends State<PenjadwalanPerawatanScreen> {
  final _formKey = GlobalKey<FormState>();
  var _assetIdController = TextEditingController();
  final _jenisPerawatanController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _teknisiController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _assetIdController =
        TextEditingController(text: widget.assetId); // Inisialisasi controller
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitJadwal() async {
    if (_formKey.currentState!.validate()) {
      // 1. Ambil data dari form
      String assetId = _assetIdController.text;
      String jenisPerawatan = _jenisPerawatanController.text;
      DateTime tanggal = _selectedDate;
      String waktu = _selectedTime.format(context);
      String? teknisi = _teknisiController.text;
      String? catatan = _catatanController.text;

      DataService dataService = DataService();
      String response = await dataService.insertMaintenanceSchedule(
        '677a3903f853312de5509e51',
        assetId,
        jenisPerawatan,
        tanggal.toString().split(' ')[0],
        waktu,
        teknisi,
        'Terjadwal',
        catatan,
      );

      // 3. Proses response
      if (response != '[]') {
        // Data berhasil disimpan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Jadwal perawatan berhasil ditambahkan!')),
        );

        // 4. Bersihkan form
        _formKey.currentState!.reset();
      } else {
        // Terjadi error saat menyimpan data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan jadwal perawatan.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjadwalan Perawatan'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //Menambahkan Nama Jenis Perawatan
              Text(
                "Jenis Perawatan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _jenisPerawatanController,
                decoration: InputDecoration(
                  hintText: 'Masukkan jenis perawatan',
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
                    return 'Jenis perawatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              //Menambahkan Pilih Tanggal
              Text(
                "Pilih Tanggal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  DateFormat('dd-MM-yyyy').format(_selectedDate)),
              ),
              const SizedBox(height: 16.0),
              //Menambahkan Pilih Waktu
              Text(
                "Pilih Waktu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(_selectedTime.format(context)),
              ),
              const SizedBox(height: 16.0),

              //Menambahkan Nama Teknisi
              Text(
                "Nama Teknisi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),SizedBox(height: 10),
              TextFormField(
                controller: _teknisiController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nama Teknisi',
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
              ),
              const SizedBox(height: 16.0),

              //Menambahkan Nama catatan
              Text(
                "catatan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _catatanController, maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Masukkan catatan',
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
              ),

              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitJadwal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna latar belakang
                  foregroundColor: Colors.white, // Warna teks
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('SIMPAN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DaftarJadwalScreen extends StatelessWidget {
  const DaftarJadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {

    DataService dataService = DataService(); // Buat objek DataService

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Jadwal Perawatan'),
      ),
      body: FutureBuilder<dynamic>(
        future: dataService.selectAll(
          '671063f5ec5074ec8261d115',
          'manajemen_aset',
          'maintenance_schedule',
          '677a3903f853312de5509e51',
        )            .then((value) => jsonDecode(value)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada jadwal perawatan.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var jadwal = snapshot.data![index];
                return ListTile(
                  title: Text(jadwal['assetid'] ?? ''),
                  // subtitle: Text('${jadwal.jenisPerawatan} - ${DateFormat('dd-MM-yyyy').format(jadwal.tanggal)} ${jadwal.waktu}'),
                  // ... tambahkan informasi lain yang ingin ditampilkan ...
                );
              },
            );
          }
        },
      ),
    );
  }
}
