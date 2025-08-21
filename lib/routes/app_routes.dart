import 'package:get/get.dart';
import 'package:the_game/app/app_binding.dart';
import 'package:the_game/features/game/game_page.dart';
import 'package:the_game/features/home/home_page.dart';

class AppRoutes {
  static const home = '/';
  static const game = '/game';
}

abstract class AppPages {
  static const initial = AppRoutes.home;

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: AppBinding(),
    ),
    GetPage(name: AppRoutes.game, page: () => const GamePage()),
  ];
}
