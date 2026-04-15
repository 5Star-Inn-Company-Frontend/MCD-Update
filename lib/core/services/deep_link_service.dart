import 'dart:async';
import 'dart:developer' as dev;
import 'dart:ui';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';

class DeepLinkService extends GetxService {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final _box = GetStorage();

  // centralized deep link domain
  static const String deepLinkDomain = 'mcd.5starcompany.com.ng';
  static const String claimPath = '/giveaway/claim';

  // storage keys for pending deep link
  static const String _pendingIdKey = 'pending_deeplink_giveaway_id';
  static const String _pendingRouteKey = 'pending_deeplink_route';

  Future<DeepLinkService> init() async {
    _appLinks = AppLinks();

    // check initial link when app starts
    _checkInitialLink();

    // setup listener for runtime links
    _setupDeepLinkListener();

    return this;
  }

  /// build a shareable claim link
  static String buildClaimLink(int giveawayId) {
    return 'https://$deepLinkDomain$claimPath?id=$giveawayId';
  }

  /// save a pending giveaway ID and optional route for later consumption.
  void savePendingGiveawayId(int id, {String? route}) {
    dev.log('saving pending giveaway id: $id, route: $route', name: 'DeepLink');
    _box.write(_pendingIdKey, id);
    if (route != null) {
      _box.write(_pendingRouteKey, route);
    } else {
      _box.remove(_pendingRouteKey);
    }
  }

  Future<void> _checkInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        handleDeepLink(initialUri);
      }
    } catch (e) {
      dev.log('error checking initial link: $e', name: 'DeepLink');
    }
  }

  void _setupDeepLinkListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        handleDeepLink(uri);
      },
      onError: (err) {
        dev.log('link stream error: $err', name: 'DeepLink');
      },
    );
    dev.log('deep link listener started', name: 'DeepLink');
  }

  void handleDeepLink(Uri uri) {
    dev.log('handling deep link: $uri', name: 'DeepLink');

    // supports mcd://giveaway/claim and https://mcd.com/giveaway/claim
    final bool isClaimLink = uri.path.contains(claimPath) ||
        (uri.host == 'giveaway' && uri.path.contains('/claim'));

    if (isClaimLink) {
      final rawId = uri.queryParameters['id'];
      if (rawId == null) return;

      final id = int.tryParse(rawId);
      if (id == null) {
        dev.log('invalid giveaway id in deep link: $rawId', name: 'DeepLink');
        return;
      }

      _navigateWithAuthCheck(id);
    }
  }

  void _navigateWithAuthCheck(int id) {
    final token = _box.read('token');
    final String currentRoute = Get.currentRoute;

    // if we are still on splash screen or initializing, always defer
    final bool isInitializing =
        currentRoute == Routes.SPLASH_SCREEN || currentRoute.isEmpty;

    if (isInitializing) {
      dev.log('app initializing, deferring deep link navigation: $id',
          name: 'DeepLink');
      savePendingGiveawayId(id, route: Routes.GIVEAWAY_MODULE);
      return;
    }

    if (token == null || token.toString().isEmpty) {
      dev.log('user not logged in, saving pending deep link', name: 'DeepLink');

      // persist the giveaway id so we can navigate after login
      savePendingGiveawayId(id, route: Routes.GIVEAWAY_MODULE);

      Get.snackbar(
        'Login Required',
        'Please login to claim your giveaway',
        backgroundColor: const Color(0xffE5E5E5),
      );
      Get.toNamed(Routes.LOGIN_SCREEN);
    } else {
      dev.log('navigating to giveaway module: $id', name: 'DeepLink');
      Get.toNamed(Routes.GIVEAWAY_MODULE, arguments: {'id': id});
    }
  }

  /// check and consume any pending deep link.
  /// call this after splash screen or login.
  bool consumePendingDeepLink() {
    final pendingId = _box.read(_pendingIdKey);
    if (pendingId != null) {
      final String targetRoute =
          _box.read(_pendingRouteKey) ?? Routes.GIVEAWAY_MODULE;
      _box.remove(_pendingIdKey);
      _box.remove(_pendingRouteKey);

      dev.log('consuming pending giveaway $pendingId for route $targetRoute',
          name: 'DeepLink');

      // schedule navigation to avoid conflicts with current navigation
      Future.delayed(const Duration(milliseconds: 500), () {
        // use arguments map consistently
        final args = {
          'id': pendingId,
          'giveaway_id': pendingId,
        };

        Get.toNamed(targetRoute, arguments: args);
      });
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }
}
