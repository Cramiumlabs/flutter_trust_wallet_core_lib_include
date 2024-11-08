import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:flutter_trust_wallet_core_example/bitcoin_address_example.dart';
import 'package:flutter_trust_wallet_core_example/bitcoin_transaction_example.dart';
import 'package:flutter_trust_wallet_core_example/ethereum_example.dart';
import 'package:flutter_trust_wallet_core_example/private_key_is_valid_example.dart';
import 'package:flutter_trust_wallet_core_example/tron_example.dart';

List<String> logs = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late HDWallet wallet;
  late PrivateKey masterKey;

  @override
  void initState() {
    FlutterTrustWalletCore.init();
    super.initState();
    String mnemonic =
        "rent craft script crucial item someone dream federal notice page shrug pipe young hover duty"; // 有测试币的 tron地址
    wallet = HDWallet.createWithMnemonic(mnemonic);
    // wallet = HDWallet();

    // List<int> numbers = [
    //   138,
    //   51,
    //   59,
    //   196,
    //   104,
    //   74,
    //   12,
    //   193,
    //   100,
    //   40,
    //   192,
    //   160,
    //   165,
    //   109,
    //   67,
    //   217,
    //   14,
    //   144,
    //   98,
    //   56,
    //   152,
    //   72,
    //   175,
    //   101,
    //   55,
    //   47,
    //   236,
    //   206,
    //   129,
    //   46,
    //   26,
    //   81
    // ];
    // Uint8List data = Uint8List.fromList(numbers);
    // wallet = HDWallet.createWithData(data);

    masterKey = wallet.getMaterKey(TWCurve.TWCurveSECP256k1);
    wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum);
    wallet.getAddressForCoin(TWCoinType.TWCoinTypeEthereum);
    // String data = masterKey.data().toString();
    // print(data);
  }

  Widget _exampleItem({
    required String name,
    required WidgetBuilder builder,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: builder));
      },
      child: Text(name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('wallet core example app'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(wallet.mnemonic()),
            Text(masterKey.data().toString()),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _exampleItem(
                    name: 'Ethereum',
                    builder: (_) {
                      return EthereumExample(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'Bitcoin Address',
                    builder: (_) {
                      return BitcoinAddressExample(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'Bitcoin Transaction',
                    builder: (_) {
                      return BitcoinTransactionExample(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'Tron',
                    builder: (_) {
                      return TronExample(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'PrivateKey.isValid(a,b)',
                    builder: (_) {
                      return PrivateKeyIsValidExample(wallet);
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                wallet.delete();
                wallet = HDWallet();
                masterKey = wallet.getMaterKey(TWCurve.TWCurveED25519);
                setState(() {});
              },
              child: Text("gen"),
            ),
          ],
        ),
      ),
    );
  }
}
