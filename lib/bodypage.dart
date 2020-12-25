import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flashlight/flashlight.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:battery_indicator/battery_indicator.dart';
import 'package:battery/battery.dart';

class BodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  bool _bSwitch = true;
  String sText = "OFF";
  Color fontColor = Colors.grey[200], batteryColor = Colors.green[700];
  Battery _battery = Battery();
  StreamSubscription<BatteryState> _batteryStateSubscription;
  int batteryLvl = 0;

  void initState() {
    super.initState();
    batteryLvl = batteryPercentage();
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() async {
        batteryLvl = await _battery.batteryLevel;
        batteryColor = batteryLvl <= 20
            ? Colors.red[900]
            : batteryLvl <= 50
                ? Colors.orange[800]
                : Colors.green[900];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
  }

  batteryPercentage() async {
    return await _battery.batteryLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('\n\n'),
              Transform.rotate(
                angle: 300,
                child: BatteryIndicator(
                  style: BatteryIndicatorStyle.values[1],
                  colorful: true,
                  showPercentNum: false,
                  mainColor: batteryColor,
                  size: 30.0,
                  ratio: 3.5,
                  showPercentSlide: true,
                ),
              ),
              Text('$batteryLvl'),
            ],
          ),
          Column(
            children: [
              Text('\n'),
              Text(
                'Your 🔦 is $sText \n',
                style: TextStyle(fontSize: 24, color: fontColor),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                child: FittedBox(
                  child: FloatingActionButton(
                      onPressed: () {
                        mainState();
                      },
                      child: Icon(
                        Icons.power_settings_new,
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[300]),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text('Created by Varun Gaikwad \n'),
              IconButton(
                  icon: FaIcon(FontAwesomeIcons.github), onPressed: _launchGIT),
              Text('\n'),
            ],
          )
        ],
      ),
    ));
  }

  mainState() {
    setState(() {
      _bSwitch ? Flashlight.lightOn() : Flashlight.lightOff();
      sText = _bSwitch ? "ON " : "OFF";
      _bSwitch = !_bSwitch;
    });
  }

  _launchGIT() async {
    String url = 'https://github.com/VarunGaikwad';
    if (await canLaunch(url))
      await launch(url);
    else
      throw 'Could not launch $url';
  }
}
