import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_online/models/barang_model.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/services/url.dart' as url;

class BarangService {

  Future getBarang() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: "Anda belum login / token invalid",
      );
    }

    var uri = Uri.parse("${url.BaseUrl}/admin/getbarang");

    Map<String, String> headers = {
      "Authorization": "Bearer ${user.token}",
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data["status"] == true) {
        List<BarangModel> barang =
            (data["data"] as List)
                .map((e) => BarangModel.fromJson(e))
                .toList();

        return ResponseDataList(
          status: true,
          message: "Success load data",
          data: barang,
        );
      } else {
        return ResponseDataList(
          status: false,
          message: "Failed load data",
        );
      }
    } else {
      return ResponseDataList(
        status: false,
        message: "Error ${response.statusCode}",
      );
    }
  }

  Future insertBarang(request, image, id) async {
  UserLogin userLogin = UserLogin();
  var user = await userLogin.getUserLogin();

  if (user.status == false) {
    return ResponseDataList(
      status: false,
      message: "Anda belum login / token invalid",
    );
  }

  // pilih endpoint insert / update
  Uri uri;
  if (id == null) {
    uri = Uri.parse("${url.BaseUrl}/admin/insertbarang");
  } else {
    uri = Uri.parse("${url.BaseUrl}/admin/updatebarang/$id");
  }

  var requestMultipart = http.MultipartRequest("POST", uri);

  /// ⭐⭐⭐ INI BAGIAN PALING PENTING ⭐⭐⭐
  requestMultipart.headers.addAll({
    "Authorization": "Bearer ${user.token}",
    "Accept": "application/json", // WAJIB biar Laravel kirim JSON
  });

  /// FIELD TEXT
  requestMultipart.fields["nama_barang"] = request["nama_barang"];
  requestMultipart.fields["harga"] = request["harga"];
  requestMultipart.fields["stok"] = request["stok"];
  requestMultipart.fields["deskripsi"] = request["deskripsi"];

  /// FIELD IMAGE
  if (image != null) {
    requestMultipart.files.add(
      await http.MultipartFile.fromPath(
        "image", // HARUS sama dengan Postman!
        image.path,
      ),
    );
  }

  /// SEND REQUEST
  var streamedResponse = await requestMultipart.send();
  var response = await http.Response.fromStream(streamedResponse);

  print("STATUS CODE : ${response.statusCode}");
  print("BODY RESPONSE : ${response.body}");

  /// CEGAT kalau server kirim HTML
  if (!response.body.startsWith("{")) {
    return ResponseDataList(
      status: false,
      message: "Server tidak mengirim JSON (kemungkinan error backend)",
    );
  }

  var data = json.decode(response.body);

  if (response.statusCode == 200 && data["status"] == true) {
    return ResponseDataList(
      status: true,
      message: data["message"],
    );
  } else {
    return ResponseDataList(
      status: false,
      message: data["message"] ?? "Gagal simpan data",
    );
  }
}

  Future hapusBarang(id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: "Anda belum login / token invalid",
      );
    }

    var uri = Uri.parse("${url.BaseUrl}/admin/hapusbarang/$id");

    Map<String, String> headers = {
      "Authorization": "Bearer ${user.token}",
    };

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data["status"] == true) {
        return ResponseDataList(
          status: true,
          message: "Berhasil hapus data",
        );
      } else {
        return ResponseDataList(
          status: false,
          message: "Gagal hapus data",
        );
      }
    } else {
      return ResponseDataList(
        status: false,
        message: "Error ${response.statusCode}",
      );
    }
  }
}