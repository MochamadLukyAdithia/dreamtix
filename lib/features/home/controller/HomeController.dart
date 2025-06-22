import 'dart:convert';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:dreamtix/features/home/model/tiket_model.dart';
import 'package:dreamtix/features/home/model/banner_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dreamtix/core/const/apiUrl.dart' as api;

class HomeController extends GetxController {
  var tabIndex = 0.obs;
  var searchText = ''.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void updateSearch(String text) {
    searchText.value = text;
  }

  Future<List<EventModel>> getEvents() async {
    final box = GetStorage();
    final token = box.read("token");

    final url = Uri.parse('${api.apiUrl}/events');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        print(json);
        final List<dynamic> data = json["data"];

        return data.map((item) => EventModel.fromMap(item)).toList();
      } else {
        print("Gagal mengambil event: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      return [];
    }
  }

  Future<List<Tiket>> getTiketsByEventId(int idEvent) async {
    print("ID EVENT : $idEvent");
    final box = GetStorage();
    final token = box.read("token");

    final url = Uri.parse('${api.apiUrl}/events/$idEvent/tikets');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json["data"];
        final result = data.map((item) => Tiket.fromJson(item)).toList();
        print(result);
        return result;
      } else {
        print("Gagal mengambil tiket: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      return [];
    }
  }

  Future<List<BannerModel>> getBanners() async {
    final box = GetStorage();
    final token = box.read("token");

    final url = Uri.parse('${api.apiUrl}/banner'); 

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json["data"];
        final result = data.map((item) => BannerModel.fromJson(item)).toList();
        print(result);
        return result;
      } else {
        print("Gagal mengambil banner: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      return [];
    }
  }
}
