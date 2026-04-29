import 'package:toko_online/services/url.dart' as url;

class BarangModel {
  int? id;
  String? nama_barang;
  String? deskripsi;
  double? harga;
  double? stok;
  String? image;

  BarangModel({
    this.id,
    this.nama_barang,
    this.deskripsi,
    this.harga,
    this.stok,
    this.image,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      id: json["id"],
      nama_barang: json["nama_barang"],
      deskripsi: json["deskripsi"],
      harga: double.parse(json["harga"].toString()),
      stok: double.parse(json["stok"].toString()),
      image: "${url.BaseUrlTanpaAPI}/${json["image"]}",
    );
  }
}