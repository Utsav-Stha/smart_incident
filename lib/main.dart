import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/utils/app_config.dart';
import 'package:smart_incident/utils/app_routing/app_routing.dart';
import 'feature/common/constants/firebase_collection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseFirestore db = FirebaseFirestore.instance;
  // db
  //     .collection(FirebaseCollection.incidentCollection)
  //     .doc(AppConfig.instance.userId ?? "")
  //     .collection(FirebaseCollection.userIncidentCollection);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BeamerDelegate _beamerDelegate;

  @override
  void initState() {
    super.initState();
    _beamerDelegate = RouteGenerator.generateRoute();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: false,
      child: MaterialApp.router(
        key: MyApp.navigatorKey,
        debugShowCheckedModeBanner: false,
        routeInformationParser: BeamerParser(),
        routerDelegate: _beamerDelegate,
        backButtonDispatcher: BeamerBackButtonDispatcher(
          delegate: _beamerDelegate,
        ),
      ),
    );
  }
}
