package com.example.joystick

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothServerSocket
import android.bluetooth.BluetoothSocket
import android.os.Build
import java.io.IOException
import java.util.UUID


@TargetApi(Build.VERSION_CODES.GINGERBREAD_MR1)
@SuppressLint("MissingPermission")
class ConnectServerBluetooth(adapter: BluetoothAdapter, name:String,uuid:UUID):Thread() {
private val mmServerSocket:BluetoothServerSocket? by lazy(LazyThreadSafetyMode.NONE){
 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD_MR1) {
     adapter.listenUsingInsecureRfcommWithServiceRecord(name,uuid)
 } else {
     adapter.listenUsingInsecureRfcommWithServiceRecord(name,uuid)
 }
}
    override fun run(){
        var shouldloop=true
        while(shouldloop){
            val socket:BluetoothSocket? = try{
                mmServerSocket?.accept()
            }catch (e:IOException){
                shouldloop=false
                println("Socket accept failed => $e")
                null
            }
            socket.also {
//                manageMyConnectedSocket(it)
            mmServerSocket?.close()
            }
        }
    }
    fun cancel(){
        try{
            mmServerSocket?.close()
        }catch (e:IOException){
            print("Could not closer the connect socket $e")

        }
    }

}
