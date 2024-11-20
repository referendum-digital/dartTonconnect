import 'dart:convert';
import 'package:darttonconnect/exceptions.dart';
import 'package:darttonconnect/models/wallet_app.dart';
import 'package:http/http.dart' as http;

const fallbackWalletsList = [
  WalletApp(
    appName: "telegram-wallet",
    name: "Wallet",
    bridgeUrl: "https://walletbot.me/tonconnect-bridge/bridge",
    image: "https://wallet.tg/images/logo-288.png",
    aboutUrl: "https://wallet.tg/",
    universalUrl: "https://t.me/wallet?attach=wallet",
  ),
  WalletApp(
    appName: "tonkeeper",
    name: "Tonkeeper",
    bridgeUrl: "https://bridge.tonapi.io/bridge",
    image: "https://tonkeeper.com/assets/tonconnect-icon.png",
    aboutUrl: "https://tonkeeper.com",
    universalUrl: "https://app.tonkeeper.com/ton-connect",
  ),
  WalletApp(
    appName: "tonhub",
    name: "Tonhub",
    bridgeUrl: "https://connect.tonhubapi.com/tonconnect",
    image: "https://tonhub.com/tonconnect_logo.png",
    aboutUrl: "https://tonhub.com",
    universalUrl: "https://tonhub.com/ton-connect",
  ),
  WalletApp(
    appName: "bitgetTonWallet",
    name: "Bitget Wallet",
    bridgeUrl: "https://ton-connect-bridge.bgwapi.io/bridge",
    image:
        "https://raw.githubusercontent.com/bitkeepwallet/download/main/logo/png/bitget_wallet_logo_0_gas_fee.png",
    aboutUrl: "https://web3.bitget.com",
    universalUrl: "https://bkcode.vip/ton-connect",
  ),
  WalletApp(
    appName: "safepalwallet",
    name: "SafePal",
    bridgeUrl: "https://ton-bridge.safepal.com/tonbridge/v1/bridge",
    image: "https://s.pvcliping.com/web/public_image/SafePal_x288.png",
    aboutUrl: "https://www.safepal.com",
    universalUrl: "https://link.safepal.io/ton-connect",
  ),
  WalletApp(
    appName: "okxMiniWallet",
    name: "OKX Mini Wallet",
    bridgeUrl: "https://www.okx.com/tonbridge/discover/rpc/bridge",
    image: "https://static.okx.com/cdn/assets/imgs/2411/8BE1A4A434D8F58A.png",
    aboutUrl: "https://www.okx.com/web3",
    universalUrl: "https://t.me/OKX_WALLET_BOT?attach=wallet",
  ),
  WalletApp(
    appName: "hot",
    name: "HOT",
    bridgeUrl: "https://sse-bridge.hot-labs.org",
    image: "https://raw.githubusercontent.com/hot-dao/media/main/logo.png",
    aboutUrl: "https://hot-labs.org/",
    universalUrl: "https://t.me/herewalletbot?attach=wallet",
  ),
  WalletApp(
    appName: "GateWallet",
    name: "GateWallet",
    bridgeUrl: "https://dapp.gateio.services/tonbridge_api/bridge/v1",
    image:
        "https://img.gatedataimg.com/prd-ordinal-imgs/036f07bb8730716e/gateio-0925.png",
    aboutUrl: "https://www.gate.io/",
    universalUrl: "https://gateio.go.link/gateio/web3?adj_t=1ff8khdw_1fu4ccc7",
  ),
];

class WalletsListManager {
  String _walletsListSource =
      'https://raw.githubusercontent.com/ton-blockchain/wallets-list/main/wallets-v2.json';
  final int? _cacheTtl;

  dynamic _dynamicWalletsListCache;
  List<WalletApp> walletsListCache = [];
  int? _walletsListCacheCreationTimestamp;

  WalletsListManager({String? walletsListSource, int? cacheTtl})
      : _cacheTtl = cacheTtl {
    if (walletsListSource != null) {
      _walletsListSource = walletsListSource;
    }
  }

  Future<List<WalletApp>> getWallets() async {
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (_cacheTtl != null &&
        _walletsListCacheCreationTimestamp != null &&
        currentTimestamp > _walletsListCacheCreationTimestamp! + _cacheTtl!) {
      _dynamicWalletsListCache = null;
    }

    if (_dynamicWalletsListCache == null) {
      List<WalletApp> walletsList = [];
      try {
        final response = await http.get(Uri.parse(_walletsListSource));
        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          if (responseBody is List) {
            walletsList =
                responseBody.map((e) => WalletApp.fromMap(e)).toList();
          } else {
            throw FetchWalletsError(
                'Wrong wallets list format, wallets list must be an array.');
          }
        } else {
          throw FetchWalletsError('Failed to fetch wallets list.');
        }
      } on FetchWalletsError {
        walletsList = fallbackWalletsList;
      }

      walletsListCache = [];
      for (final wallet in walletsList) {
        walletsListCache.add(wallet);
      }

      _walletsListCacheCreationTimestamp = currentTimestamp;
    }

    return walletsListCache;
  }
}
