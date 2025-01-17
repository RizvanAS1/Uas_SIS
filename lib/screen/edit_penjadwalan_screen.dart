import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/utilis/api_config.dart';

import '../data_service.dart';
import '../models/maintenance_schedule.dart';

class EditJadwalanPerawatanScreen extends StatefulWidget {
  final MaintenanceScheduleModel jadwal;

  const EditJadwalanPerawatanScreen({super.key, required this.jadwal});

  @override
  State<EditJadwalanPerawatanScreen> createState() =>
      _EditJadwalanPerawatanScreenState();
}

class _EditJadwalanPerawatanScreenState
    extends State<EditJadwalanPerawatanScreen> {
  DataService dataService = DataService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jenisPerawatanController;
  late TextEditingController _teknisiController;
  late TextEditingController _catatanController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _jenisPerawatanController =
        TextEditingController(text: widget.jadwal.jenisPerawatan);
    _teknisiController = TextEditingController(text: widget.jadwal.teknisi ?? '');
    _catatanController = TextEditingController(text: widget.jadwal.catatan ?? '');
    _selectedDate = widget.jadwal.tanggal;
    _selectedTime = TimeOfDay(
        hour: int.parse(widget.jadwal.waktu.split(':')[0]),
        minute: int.parse(widget.jadwal.waktu.split(':')[1].split(' ')[0]));
  }

  @override
  void dispose() {
    _jenisPerawatanController.dispose();
    _teknisiController.dispose();
    _catatanController.dispose();
    super.dispose();
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
      String jenisPerawatan = _jenisPerawatanController.text;
      DateTime tanggal = _selectedDate;
      String waktu = _selectedTime.format(context);
      String? teknisi = _teknisiController.text;
      String? catatan = _catatanController.text;

      // 2. Gabungkan nama field dan nilai field
      String updateFields =
          'jenis_perawatan~tanggal~waktu~teknisi~catatan';
      String updateValues =
          '$jenisPerawatan~$tanggal~$waktu~$teknisi~$catatan';

      // 3. Panggil fungsi updateId
      dataService
          .updateId(
        updateFields,
        updateValues,
        token,
        'manajemen_aset',
        'maintenance_schedule',
        appId,
        widget.jadwal.id, // Ganti dengan ID aset
      )
          .then((value) {Navigator.pop(context);                      Navigator.pop(context);
      }).catchError((error) {

        print('Error updating data: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
          Text('Gagal menyimpan data. Silakan coba lagi.'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Penjadwalan Perawatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Tampilkan dialog konfirmasi
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi Hapus'),
                  content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Panggil fungsi untuk menghapus jadwal
                        bool success = await dataService.removeId(
                            token,
                            project,
                            'maintenance_schedule',
                            appId,
                            widget.jadwal.id);

                        if (success) {
                          // Hapus berhasil
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Jadwal berhasil dihapus!')),
                          );
                          Navigator.pop(context); // Tutup dialog
                          Navigator.pop(context); // Kembali ke halaman sebelumnya
                        } else {
                          // Hapus gagal
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gagal menghapus jadwal.')),
                          );
                        }
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
