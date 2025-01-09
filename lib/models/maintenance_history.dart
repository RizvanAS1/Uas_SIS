class MaintenanceHistoryModel {
  final String id;
  final String scheduleId;
  final DateTime tanggalSelesai;
  final double? biaya;
  final String? keterangan;

  MaintenanceHistoryModel({
    required this.id,
    required this.scheduleId,
    required this.tanggalSelesai,
    this.biaya,
    this.keterangan,
  });

  factory MaintenanceHistoryModel.fromJson(Map<String, dynamic> data) {
    return MaintenanceHistoryModel(
      id: data['_id'],
      scheduleId: data['scheduleId'],
      tanggalSelesai: DateTime.parse(data['tanggalSelesai']), // Asumsi 'tanggalSelesai' bertipe String dalam format yang bisa di-parse
      biaya: data['biaya'],
      keterangan: data['keterangan'],
    );
  }
}