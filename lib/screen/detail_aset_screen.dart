import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/screen/penjadwalan_screen.dart';
import 'package:provider/provider.dart';

import '../data_service.dart';
import '../models/user.dart';
import 'edit_aset_screen.dart';

class DetailAsetScreen extends StatelessWidget {
  final Map<String, dynamic> aset; // Terima data aset sebagai parameter

  const DetailAsetScreen({Key? key, required this.aset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataService dataService = DataService();

    final userRole = Provider.of<UserProvider>(context).currentUser!.role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aset'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (userRole == Role.admin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAsetScreen(aset: aset),
                  ),
                );
              },
            ),
          if (userRole == Role.admin)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi Hapus'),
                      content: const Text(
                          'Apakah Anda yakin ingin menghapus aset ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            dataService.removeId(                  '671063f5ec5074ec8261d115',
                                'manajemen_aset',
                                'aset',
                                '677a3903f853312de5509e51', aset['_id']);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text('Nama: ${aset['nama']}'),
                ),
              ),
              const SizedBox(height: 8.0), // Jarak antar Container
              SizedBox(width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text('Kategori: ${aset['kategori']}'),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text('Lokasi: ${aset['lokasi']}'),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text('Kondisi: ${aset['kondisi']}'),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<dynamic>(
                future: dataService.selectId(
                  '671063f5ec5074ec8261d115',
                  'manajemen_aset',
                  'maintenance_schedule',
                  '677a3903f853312de5509e51', aset['_id']
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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var jadwal = snapshot.data![index];
                        return ListTile(
                          title: Text('${jadwal.jenisPerawatan} - ${DateFormat('dd-MM-yyyy').format(jadwal.tanggal)} ${jadwal.waktu}'),
                        );
                      },
                    );
                  }
                },
              ),
              if (userRole == Role.admin)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PenjadwalanPerawatanScreen(
                          assetId: aset['_id'],
                        ),
                      ),
                    );
                  },
                  child: const Text('Jadwalkan Perawatan'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
