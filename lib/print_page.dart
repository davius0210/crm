import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';


void main() {
  runApp(const MaterialApp(
    title: 'Print',
    home: PrintPage(),
  ));
}

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => LayerPrint();
}

class LayerPrint extends State<PrintPage> {
  bool bConnect = false;
  String tips = 'no device connect';
  List<BluetoothInfo> items = [];
  String _address = ""; // Menyimpan alamat mac address terpilih

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  // Pengganti connectBluetooth
  Future<void> initBluetooth() async {
    final bool isBluetoothOn = await PrintBluetoothThermal.bluetoothEnabled;
    if (isBluetoothOn) {
      getBluetoothList();
    } else {
      setState(() {
        tips = 'bluetooth off';
      });
    }
  }

  // Mendapatkan daftar perangkat
  Future<void> getBluetoothList() async {
    setState(() => tips = 'scanning...');
    final List<BluetoothInfo> list = await PrintBluetoothThermal.pairedBluetooths;
    setState(() {
      items = list;
      tips = items.isEmpty ? 'no paired devices' : 'select a device';
    });
  }

  // Menghubungkan ke printer
  Future<void> connect(String address) async {
    setState(() {
      tips = 'connecting...';
      _address = address;
    });

    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: address);
    
    setState(() {
      bConnect = result;
      tips = result ? 'connected' : 'connection failed';
    });
  }

  // Memutuskan koneksi
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    setState(() {
      bConnect = false;
      tips = 'disconnected';
    });
  }

  // Fungsi Cetak (Mirip printTest)
  Future<void> printTest() async {
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (!isConnected) return;

    // Membuat format struk
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.reset();
    bytes += generator.text("TEST PRINT", styles: const PosStyles(bold: true, align: PosAlign.center));
    bytes += generator.text("Bluetooth Printer Thermal", styles: const PosStyles(align: PosAlign.center));
    bytes += generator.feed(2);
    bytes += generator.cut();

    final bool result = await PrintBluetoothThermal.writeBytes(bytes);
    print("Print result: $result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Do Print')),
      body: RefreshIndicator(
        onRefresh: getBluetoothList,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Status: $tips"),
              ),
              const Divider(),
              // Daftar perangkat yang terpasang (Paired)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].name),
                    subtitle: Text(items[index].macAdress),
                    onTap: () => connect(items[index].macAdress),
                    trailing: _address == items[index].macAdress && bConnect
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                  );
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: bConnect ? disconnect : null,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: bConnect ? printTest : null,
                      child: const Text('Print Selftest'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}