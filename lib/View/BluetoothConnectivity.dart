import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
class BluetoothUI extends StatefulWidget {
  @override
  _BluetoothUIState createState() => _BluetoothUIState();
}

class _BluetoothUIState extends State<BluetoothUI> {
 static const methodChannel =MethodChannel('com.bluetooth.connection/method');
 RxList<dynamic> getlist=[].obs;
 RxList<dynamic> scannedlist=[].obs;

 Future<void> _searchBluetoothDevice() async{
    try{
      List? devices = await methodChannel.invokeListMethod("isBluetoothOff",addressselected);

      // List<Map<String, dynamic>> deviceList = devices!.cast<Map<String, dynamic>>();
   for(int i=0;i<devices!.length;i++){
     getlist.add({
       'name':devices[i]['name'],
       'address':devices[i]['address']
     });
   }
      // setState(() {
        print('available $getlist');
      // });
    }catch(e){
      print(e.toString());
    }
 }
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  String addressselected='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Scan'),
      ),
      body:Column(
        children: [
          ElevatedButton(onPressed: ()async{
            _searchBluetoothDevice();
          }, child: const Text('open')), ElevatedButton(onPressed: ()async{
            methodChannel.invokeMethod("StartPairing");
            
          }, child: const Text('connect')),ElevatedButton(onPressed: ()async{
               // methodChannel.invokeMethod("scandevices");
            List? scanneddevices = await methodChannel.invokeListMethod("scandevices",addressselected);
            for(int i=0;i<scanneddevices!.length;i++){
              scannedlist.add({
                'name':scanneddevices[i]['name'],
                'address':scanneddevices[i]['address']
              });
              print(scanneddevices);
            }
            // _searchBluetoothDevice();
          }, child: const Text('Scan')),
          Text("Paired devices"),

          Obx(()=>getlist.isNotEmpty?
          SizedBox(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
                itemCount:getlist.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      addressselected=getlist[index]['address'];
                      // print(addressselected);
                      if(addressselected.isNotEmpty){
                        print('works');
                        methodChannel.invokeMethod("Getadrress",addressselected);

                      }
                    },
                    child: ListTile(title: Text(getlist[index]['name']),
                    subtitle: Text(getlist[index]['address']),),
                  );
                }),
          ):SizedBox()),
    Text("scanned devices"),
    Obx(()=>scannedlist.isNotEmpty?
          SizedBox(
            height: 200,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount:scannedlist.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      // addressselected=getlist[index]['address'];
                      // print(addressselected);
                      if(addressselected.isNotEmpty){
                        print('works');
                        methodChannel.invokeMethod("Getadrress",addressselected);

                      }
                    },
                    child: ListTile(title: Text(scannedlist[index]['name']),
                      subtitle: Text(scannedlist[index]['address']),),
                  );
                }),
          ):SizedBox())
        ],
      )

    );
  }
}
