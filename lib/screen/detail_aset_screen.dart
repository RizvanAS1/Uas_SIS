import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_aset/screen/edit_penjadwalan_screen.dart';
import 'package:manajemen_aset/screen/laporan_kerusakan_screen.dart';
import 'package:manajemen_aset/screen/peminjaman_screen.dart';
import 'package:manajemen_aset/screen/pengembalian_screen.dart';
import 'package:manajemen_aset/screen/penjadwalan_screen.dart';
import 'package:manajemen_aset/screen/perawatan_screen.dart';
import 'package:provider/provider.dart';

import '../data_service.dart';
import '../models/maintenance_schedule.dart';
import '../models/user.dart';
import '../utilis/api_config.dart';
import 'edit_aset_screen.dart';

class DetailAsetScreen extends StatefulWidget {
  final Map<String, dynamic> aset;

  const DetailAsetScreen({super.key, required this.aset});

  @override
  State<DetailAsetScreen> createState() => _DetailAsetScreenState();
}

class _DetailAsetScreenState extends State<DetailAsetScreen> {
  DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<UserProvider>(context).currentUser!.role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aset'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (userRole == Role.user)
            IconButton(
              icon: const Icon(Icons.report_gmailerrorred),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LaporKerusakanScreen(asetId: widget.aset['_id']),
                  ),
                );
              },
            ),
          if (userRole == Role.admin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAsetScreen(aset: widget.aset),
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
                            dataService.removeId(
                                '671063f5ec5074ec8261d115',
                                'manajemen_aset',
                                'aset',
                                '677a3903f853312de5509e51',
                                widget.aset['_id']);
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
              //Menampilkan Gambar Aset
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  fileUri + widget.aset['gambar'],
                  width: 300,
                  // Sesuaikan lebar gambar
                  height: 300,
                  // Sesuaikan tinggi gambar
                  fit: BoxFit.cover,
                  // Atur bagaimana gambar ditampilkan
                  errorBuilder: (context, error, stackTrace) {
                    // Tampilkan widget alternatif jika gambar tidak ada
                    return const SizedBox(
                      width: 200,
                      height: 200,
                      child: Icon(Icons.image_not_supported_outlined),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              //Menampilkan Nama Aset
              SizedBox(height: 20),
              Text(
                widget.aset['nama'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              //Menampilkan Informasi Aset
              SizedBox(height: 10),
              const Divider(),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        IntrinsicWidth(
                          child: Text(
                            widget.aset['kategori'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Lokasi',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        IntrinsicWidth(
                          child: Text(
                            widget.aset['lokasi'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Kondisi',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        IntrinsicWidth(
                          child: Text(
                            widget.aset['kondisi'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              const Divider(),
              const SizedBox(height: 10),

              if (userRole != Role.user)
                FutureBuilder<List<MaintenanceScheduleModel>>(
                  future: dataService
                      .selectWhere(token, project, 'maintenance_schedule',
                          appId, 'assetid', widget.aset['_id'])
                      .then((value) {
                    List<dynamic> jsonData = jsonDecode(value);
                    List<MaintenanceScheduleModel> jadwalList = jsonData
                        .map((item) => MaintenanceScheduleModel.fromJson(item))
                        .toList();
                    return jadwalList;
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Tidak ada jadwal perawatan.'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var jadwal = snapshot.data![index];
                          return ListTile(
                            onTap: () {
                              if (userRole == Role.admin) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditJadwalanPerawatanScreen(
                                        jadwal: jadwal
                                      ), // Kirim data jadwal ke formulir
                                    ));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PerawatanScren(
                                        jadwal: jadwal,
                                        asetId: widget.aset['_id'],
                                      ), // Kirim data jadwal ke formulir
                                    ));
                              }
                            },
                            title: Text(
                              '${jadwal.jenisPerawatan} - ${DateFormat('dd-MM-yyyy').format(jadwal.tanggal)} ${jadwal.waktu}', // Potensi error di sini
                            ),
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
                            assetId: widget.aset['_id'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('JADWALKAN PERAWATAN'),
                  ),
                ),

              if (userRole == Role.user)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PeminjamanAsetScreen(aset: widget.aset),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('PINJAM ASET'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PengembalianAsetScreen(aset: widget.aset),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        // Warna latar belakang
                        foregroundColor: Colors.white,
                        // Warna teks
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('KEMBALIKAN ASET'),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
