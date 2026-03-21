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

    if (token == null || token.toString().isEmpty) {
      dev.log('user not logged in, saving pending deep link', name: 'DeepLink');

      // persist the giveaway id so we can navigate after login
      _box.write(_pendingIdKey, id);

      Get.snackbar(
        'Login Required',
        'Please login to claim your giveaway',
        backgroundColor: const Color(0xffE5E5E5),
      );
      Get.toNamed(Routes.LOGIN_SCREEN);
    } else {
      dev.log('navigating to giveaway detail: $id (auto_claim: true)',
          name: 'DeepLink');
      Get.toNamed(Routes.GIVEAWAY_DETAIL,
          arguments: {'id': id, 'auto_claim': true});
    }
  }

  /// check and consume any pending deep link after successful login.
  /// call this from the login success handler.
  bool consumePendingDeepLink() {
    final pendingId = _box.read(_pendingIdKey);
    if (pendingId != null) {
      _box.remove(_pendingIdKey);
      dev.log('consuming pending deep link: giveaway $pendingId',
          name: 'DeepLink');

      // schedule navigation after current frame to avoid conflicts with
      // login success navigation (offAllNamed)
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.toNamed(Routes.GIVEAWAY_DETAIL,
            arguments: {'id': pendingId, 'auto_claim': true});
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
