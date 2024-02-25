import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:summishare/theme/baseTheme.dart';
import 'bloc/shared_links/shared_links_bloc.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(const SummishareApp());
}

class SummishareApp extends StatefulWidget {
  const SummishareApp({super.key});

  @override
  State<SummishareApp> createState() => _SummishareAppState();
}

class _SummishareAppState extends State<SummishareApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SharedLinksBloc(),
          )
        ],
        child: MaterialApp(
          theme: baseTheme,
          home: const MainScreen(),
        ));
  }
}
