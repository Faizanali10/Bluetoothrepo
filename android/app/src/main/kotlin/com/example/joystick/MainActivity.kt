package com.example.joystick

import android.Manifest
import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build.*
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat.*
import io.flutter.plugin.common.BinaryMessenger
import java.io.IOException
import java.util.UUID

@Suppress("DEPRECATION")
class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.bluetooth.connection/method"
    private val discoveredDevices = mutableListOf<BluetoothDevice>()

    private var methodChannel: MethodChannel? = null
    private var scanfinished=0

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                BluetoothAdapter.ACTION_DISCOVERY_STARTED->{
                    println("started discovery")
                }
                BluetoothAdapter.ACTION_DISCOVERY_FINISHED->{
                    destroyscandiscovery()
                    println("started discovery finished")
                    scanfinished=1

                }
                BluetoothDevice.ACTION_FOUND -> {
                    val device: BluetoothDevice? =
                        intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    device?.let {
                        discoveredDevices.add(it)
    println("it device $it")
                    }
                    println("Discovered device: $device")

                }
            }

        }
    }


        override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
            super.configureFlutterEngine(flutterEngine)
            setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)
        }

        private fun setupChannels(context: Context, messenger: BinaryMessenger) {
            methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
            methodChannel!!.setMethodCallHandler { call, result ->
                if (call.method == "isBluetoothOff") {
                    val context: Context = applicationContext

                    println("call method workin")

                    if (checkSelfPermission(
                            this,
                            Manifest.permission.BLUETOOTH_CONNECT
                        ) == PackageManager.PERMISSION_DENIED
                    ) {
                        if (VERSION.SDK_INT >= 31) {
                            ActivityCompat.requestPermissions(
                                this,
                                arrayOf(Manifest.permission.BLUETOOTH_CONNECT), 1
                            )
                        }
                    }
                    if (VERSION.SDK_INT >= 31) {
                        val bluetoothManager =
                            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
                        val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
                        if (bluetoothAdapter!!.isEnabled) {
                            if(checkSelfPermission(this,Manifest.permission.ACCESS_FINE_LOCATION)==PackageManager.PERMISSION_DENIED){
                                if (VERSION.SDK_INT >= 31) {
                                    ActivityCompat.requestPermissions(
                                        this,
                                        arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 1
                                    )
                                }
                                if(checkSelfPermission(this,Manifest.permission.ACCESS_BACKGROUND_LOCATION)==PackageManager.PERMISSION_DENIED) {
                                    if (VERSION.SDK_INT >= 31) {
                                        ActivityCompat.requestPermissions(
                                            this,
                                            arrayOf(Manifest.permission.ACCESS_BACKGROUND_LOCATION),
                                            1
                                        )
                                    }

                                }
                            }

//                            bluetoothAdapter.startDiscovery()
                            val pairedDevices: Set<BluetoothDevice>? =
                                bluetoothAdapter.bondedDevices
                            val pairedDevice = pairedDevices?.map {
                                mapOf(
                                    "name" to it.name,
                                    "address" to it.address
                                )
                            }
                            result.success(pairedDevice)
                            println(" pair device get $pairedDevices")

                        }
                        if (!bluetoothAdapter.isEnabled) {
                            println("this enable bluetooth")
                            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                            startActivityForResult(enableBtIntent, 1)
                            println("StaratActivityForResult working")
                            val pairedDevices: Set<BluetoothDevice>? =
                                bluetoothAdapter.bondedDevices
                            val pairedDevice = pairedDevices?.map {
                                mapOf(
                                    "name" to it.name,
                                    "address" to it.address
                                )
                            }
                            result.success(pairedDevice)
                            println(" pair device get $pairedDevice")

                        }
                    }


                } else if (call.method == "Getadrress") {
                    val context: Context = applicationContext
                    val bluetoothManager =
                        context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
                    val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
                    val gettingaddress = call.arguments
                    println("address get from flutter $gettingaddress")
                }
                else if(call.method=="scandevices"){
                    if (checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN)
                        != PackageManager.PERMISSION_GRANTED) {
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(Manifest.permission.BLUETOOTH_SCAN),
                            1
                        )
                    } else {
                        // Start Bluetooth discovery
                        startDiscovery()
                        if (scanfinished==1){
                            val scandevices=discoveredDevices.map {
                                mapOf(
                                    "name" to it.name,
                                    "address" to it.address,
                                    "uuid" to it.uuids
                                )

                            }
                            result.success(scandevices)
                        }

                    }

//                    startDiscovery()
                }

                else if(call.method=="StartPairing"){
                    val bluetoothManager =
                        context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
                    val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
                    val bluetoothDevice = bluetoothAdapter?.getRemoteDevice("78:02:B7:E0:B8:BA")

                    val connectThread = ConnectThread(bluetoothDevice!!)
                    connectThread.start()

//                    println("socket connect or not ${socket?.connect()}")
                }

            }


        }
        private fun startDiscovery(){
            val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
//            val filter =
//            val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)

            registerReceiver(receiver, filter)
            registerReceiver(receiver,IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_STARTED))
            registerReceiver(receiver, IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED))
            val bluetoothManager =
                context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
            if(checkSelfPermission(this,Manifest.permission.BLUETOOTH_ADMIN)==PackageManager.PERMISSION_DENIED){
                if (VERSION.SDK_INT >= 31) {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.BLUETOOTH_ADMIN), 1
                    )
                }
            }
            else{
                if (bluetoothAdapter != null) {
                    if(bluetoothAdapter.isEnabled){
                        bluetoothAdapter?.startDiscovery()
                        println("Start discovery ${bluetoothAdapter?.startDiscovery()}")
                    }
                }

            }
        }


        override fun onDestroy() {
            teardownChannels()
            super.onDestroy()
        }
    private fun destroyscandiscovery(){
        val bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
        if (checkSelfPermission(
                this,
                Manifest.permission.BLUETOOTH_SCAN
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            bluetoothAdapter?.cancelDiscovery()
println("cancel discovery ${bluetoothAdapter?.cancelDiscovery()}")
        }
    }

        private fun teardownChannels() {

        }
    private val MY_UUID: UUID = UUID.fromString("6e965e31-8016-49da-ad08-134e0f52ab9a") // Example UUID for SPP
//
//
//    @SuppressLint("MissingPermission")
//    private inner class ConnectThread(private val device: BluetoothDevice?) : Thread() {
//        private val mmSocket: BluetoothSocket? by lazy(LazyThreadSafetyMode.NONE) {
//            device?.createRfcommSocketToServiceRecord(MY_UUID)
//        }
//
//        @SuppressLint("MissingPermission")
//        override fun run() {
//            val bluetoothManager =
//                context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
//            val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
//            bluetoothAdapter?.cancelDiscovery()
//
//            try {
//                mmSocket?.connect()
//                // Connection successful, you can now use the socket for communication
//            } catch (e: IOException) {
//                e.printStackTrace()
//                // Handle connection error
//            }
//        }
//
//        fun cancel() {
//            try {
//                mmSocket?.close()
//            } catch (e: IOException) {
//                e.printStackTrace()
//            }
//        }
//    }







    @SuppressLint("MissingPermission")
    private inner class ConnectThread(device: BluetoothDevice) : Thread() {

        private val mmSocket: BluetoothSocket? by lazy(LazyThreadSafetyMode.NONE) {
            device.createRfcommSocketToServiceRecord(MY_UUID)
        }

//        @SuppressLint("MissingPermission")
        public override fun run() {
            val bluetoothManager =
                context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.adapter
            // Cancel discovery because it otherwise slows down the connection.
            bluetoothAdapter?.cancelDiscovery()

            mmSocket?.let { socket ->
                // Connect to the remote device through the socket. This call blocks
                // until it succeeds or throws an exception.
                println("Socket connected ${socket.connect()}")
                socket.connect()

                // The connection attempt succeeded. Perform work associated with
                // the connection in a separate thread.
//                manageMyConnectedSocket(socket)
            }
        }

        // Closes the client socket and causes the thread to finish.
        fun cancel() {
            try {
                mmSocket?.close()
            } catch (e: IOException) {
                Log.e(TAG, "Could not close the client socket", e)
            }
        }
    }





}



