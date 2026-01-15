import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'controller/api_cont.dart' as capi;
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'controller/database_cont.dart' as cdb;
import 'controller/langganan_cont.dart' as clgn;
import 'models/langganan.dart' as mlgn;
import 'models/salesman.dart' as msf;
import 'models/globalparam.dart' as param;

class CoverageAreaPage extends StatefulWidget {
  final msf.Salesman user;
  final String startDayDate;
  final String routeName;

  const CoverageAreaPage(
      {super.key,
      required this.user,
      required this.startDayDate,
      required this.routeName});

  @override
  State<CoverageAreaPage> createState() => LayerCoverageArea();
}

class LayerCoverageArea extends State<CoverageAreaPage> {
  bool isMapReady = false;
  List<mlgn.Langganan> _listLangganan = [];
  Map<MarkerId, Marker> markers = {};
  CameraPosition _userLocation = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  Future<void> sessionExpired() async {
    await cdb.logOut();
    service.invoke("stopService");

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Session expired')));

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  void getAllLangganan() async {
    try {
      setState(() {
        isMapReady = false;
      });

      markers.clear();
      _listLangganan = await clgn.getAllLanggananCoverage(
          widget.user.fdKodeSF, widget.user.fdKodeDepo);

      List<mlgn.Langganan> listNonRute = await capi.getNonRuteLanggananInfo(
          widget.user.fdToken,
          widget.user.fdKodeSF,
          widget.user.fdKodeDepo,
          widget.startDayDate, []);

      if (listNonRute.first.code == 401) {
        await sessionExpired();
      } else if (listNonRute.first.code == 99) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text('error: ${listNonRute.first.message}')));
      }

      _listLangganan.addAll(listNonRute);

      if (_listLangganan.isNotEmpty) {
        for (var item in _listLangganan) {
          // MarkerId markerId = MarkerId(item.fdKodeExternal!);
          MarkerId markerId = MarkerId(item.fdKodeLangganan!);
          Marker markerOutlet1 = Marker(
              markerId: markerId,
              icon: BitmapDescriptor.defaultMarkerWithHue(item.isRute == 1
                  ? BitmapDescriptor.hueRed
                  : BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(
                // title: '${item.fdKodeExternal} - ${item.fdNamaLangganan}',
                title: '${item.fdNamaLangganan}',
                snippet: '${item.fdAlamat}',
              ),
              position: LatLng(item.fdLA, item.fdLG));
          markers[markerId] = markerOutlet1;
        }
      }

      setState(() {
        isMapReady = true;
      });
    } catch (e) {
      setState(() {
        isMapReady = true;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }

  void gMapInitializes(GoogleMapController controller) async {
    try {
      setState(() {
        isMapReady = false;
      });

      getAllLangganan();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: param.gpsTimeOut));
      if (position.latitude != 0 && position.longitude != 0) {
        _userLocation = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 18);
      }

      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );

      setState(() {
        isMapReady = true;
      });
    } catch (e) {
      setState(() {
        isMapReady = true;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('error load Map: $e. Mohon refresh ulang')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Coverage Area'),
          actions: [
            isMapReady
                ? IconButton(
                    onPressed: () {
                      getAllLangganan();
                    },
                    icon: Icon(Icons.refresh_outlined,
                        size: 24 * ScaleSize.textScaleFactor(context)),
                    tooltip: 'Refresh',
                  )
                : Center(
                    child: loadingProgress(ScaleSize.textScaleFactor(context))),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
           
              child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers.values),
                  initialCameraPosition: _userLocation,
                  onMapCreated: gMapInitializes),
            )
          ],
        ));
  }
}
