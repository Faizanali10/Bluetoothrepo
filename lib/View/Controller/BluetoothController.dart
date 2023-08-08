// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:get/get.dart';

// class BluetoothController extends GetxController{
//
//   FlutterBluetoothSerial flutterBluetoothSerial = FlutterBluetoothSerial.instance;
//   List<BluetoothDiscoveryResult> results = <BluetoothDiscoveryResult>[].obs;
//   RxBool isScanning = false.obs;
//   void StartScan(){
//     isScanning.toggle();
//     results.clear();
//     flutterBluetoothSerial.isEnabled.then((isEnabled){
//       if(!isEnabled!){
//         flutterBluetoothSerial.requestDisable();
//       }
//     });
//     flutterBluetoothSerial.startDiscovery().listen((devices) {
//       results.add(devices);
//     });
//   }
//   void stopScan(){
//     flutterBluetoothSerial.cancelDiscovery();
//     isScanning.toggle();
//   }
// }
