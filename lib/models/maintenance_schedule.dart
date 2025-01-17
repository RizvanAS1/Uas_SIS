class MaintenanceScheduleModel {
  final String id;
  final String assetId;
  final String jenisPerawatan;
  final DateTime tanggal;
  final String waktu;
  final String? teknisi;
  final String status;
  final String? catatan;

  MaintenanceScheduleModel({
    required this.id,
    required this.assetId,
    required this.jenisPerawatan,
    required this.tanggal,
    required this.waktu,
    this.teknisi,
    required this.status,
    this.catatan,
  });

  factory MaintenanceScheduleModel.fromJson(Map<String, dynamic> data) {
    return MaintenanceScheduleModel(
      id: data['_id'],
      assetId: data['assetid'],
      jenisPerawatan: data['jenis_perawatan'],
      tanggal: DateTime.parse(data['tanggal']), // Asumsi 'tanggal' bertipe String dalam format yang bisa di-parse
      waktu: data['waktu'],
      teknisi: data['teknisi'],
      status: data['status'],
      catatan: data['catatan'],
    );
  }
}