import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packtudo_bin2dec/hex_materialcolor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:packtudo_bin2dec/string_locale.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final HexMaterialColor defaultColor = HexMaterialColor("#1559ED");

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('pt', ''), // my language
      ],
      title: 'PackTudo - Bin2Dec',
      theme: ThemeData(
        primarySwatch: defaultColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'PackTudo - Bin2Dec', defaultColor: defaultColor),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.defaultColor}) : super(key: key);

  final String title;
  final HexMaterialColor defaultColor;

  @override
  _MyHomePageState createState() => _MyHomePageState(defaultColor);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.defaultColor);

  TextEditingController _controller;
  String _label;
  final HexMaterialColor defaultColor;
  String _resultado = "";
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.FULL_BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        //handleEvent(event, args, 'Interstitial');
      },
    );

    interstitialAd.load();
  }

  String getInterstitialAdUnitId() {
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StringLocale stringLocale = new StringLocale(context);

    if (int.tryParse(_resultado) == null) {
      _resultado = stringLocale.result;
    }

    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Center(
                      child: AdmobBanner(
                adUnitId: getBannerAdUnitId(),
                adSize: bannerSize,
                /*listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                  handleEvent(event, args, 'Banner');
                },*/
              ))),
              Center(
                  child: Text(
                    stringLocale.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: defaultColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLength: 63,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-1]"))
                ],
                onChanged: (value) {
                  setState(() {
                    var result = int.tryParse(value, radix: 2);
                    if (result != 0 && result != null) {
                      _resultado = result.toString();
                    } else {
                      _resultado = stringLocale.result;
                    }
                  });
                },
                controller: _controller,
                decoration: InputDecoration(
                  labelText: _label,
                  labelStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(color: Colors.blue, fontSize: 25.0),
              ),
              Center(
                  child: Text(
                _resultado,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: defaultColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
              Expanded(
                  child: Center(
                      child: AdmobBanner(
                adUnitId: getBannerAdUnitId(),
                adSize: bannerSize,
                /*listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                  handleEvent(event, args, 'Banner');
                },*/
              )))
            ],
          ),
        ));
  }

  String getBannerAdUnitId() {
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  /*void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('Bem vindo ao PackTudo - Bin2Dec!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Bem vindo ao PackTudo - Bin2Dec!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Saindo do PackTudo - Bin2Dec!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar(
            'Falha ao carregar os patrocinadores do PackTudo - Bin2Dec!');
        break;
      default:
    }
  }*/
}
