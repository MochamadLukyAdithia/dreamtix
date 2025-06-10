// import 'package:flutter/material.dart';
import 'package:dreamtix/features/home/model/event_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;
  var tabIndex = 0.obs;
  var searchText = ''.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void updateSearch(String text) {
    searchText.value = text;
  }

  Future<List<EventModel>> getEvents() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('events') // Ganti 'events' sesuai nama tabel kamu di Supabase
        .select();

    final List data = response;

    return data.map((item) => EventModel.fromMap(item)).toList();
  }


}
