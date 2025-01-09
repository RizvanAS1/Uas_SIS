class AsetModel {
  final String id;
  final String nama;
  final String kategori;
  final String lokasi;
  final String kondisi;
  final String deskripsi;
  final String gambar;

  AsetModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.lokasi,
    required this.kondisi,
    required this.deskripsi,
    required this.gambar
  });

  factory AsetModel.fromJson(Map data) {
    return AsetModel(
        id: data['_id'],
        nama: data['nama'],
        kategori: data['kategori'],
        lokasi: data['lokasi'],
        kondisi: data['kondisi'],
        deskripsi: data['deskripsi'],
        gambar: data['gambar']
    );
  }
}