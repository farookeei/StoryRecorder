import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/view/app.dart';
import 'config/env/env_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: '.env');
  // String environment = dotenv.get("MODE", fallback: 'MODE UNDEFINED');

  Environment().initConfig("DEV");

  runApp(const MyApp());
}
