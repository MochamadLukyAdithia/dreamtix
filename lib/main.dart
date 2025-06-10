import 'package:device_preview/device_preview.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://zktonlxkxaebbubfarxo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InprdG9ubHhreGFlYmJ1YmZhcnhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgzMTAwMDMsImV4cCI6MjA2Mzg4NjAwM30.M1yzHiNZa7HQf81n7n1Ye4TSON79ci0KYLCDWjWK0AU',
  );
  runApp(
   MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DreamTix',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
