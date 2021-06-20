import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _HomePage()
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {

  String title = "Flutter to Native";
  Color backgroundColor = Colors.red;
  // 创建 MethodChannel 这里的标志跟 ios 中设置要一致
  static const MethodChannel methodChannel = const MethodChannel('com.pages.your/native_get');
  // Flutter 调用原生
  _iOSPushToVC() {
    methodChannel.invokeMethod('FlutterToNative', ["Flutter 调用原生参数 1", "Flutter 调用原生参数 2"]);
  }

  @override
  void initState() {
    super.initState();
    // 设置原生调用 Flutter 回调,获取到方法名和参数
    methodChannel.setMethodCallHandler((MethodCall call){
      if (call.method == "NativeToFlutter") {
        setState(() {
          List<dynamic> arguments = call.arguments;
          String str = "";
          for (dynamic string in arguments) {
            str = str + " " + string;
          }
          title = str;
          backgroundColor = Colors.orange;
        });
      }
      return Future<dynamic>.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Text(title),
          onTap: (){
            _iOSPushToVC();
          },
        ),
      ),
    );
  }
}
