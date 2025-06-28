import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPicker extends StatefulWidget {
  final Function(LatLng) onPicked;
  const MapPicker({super.key, required this.onPicked});

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController? mapController;
  LatLng? picked;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
      picked = _currentPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Color(0xFFF875AA)),
              title: const Text(
                "Pilih Lokasi di Peta",
                style: TextStyle(color: Color(0xFFF875AA), fontWeight: FontWeight.w600, fontSize: 20),
              ),
              elevation: 0.5,
              centerTitle: true,
            ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _currentPosition!, zoom: 16),
                  onMapCreated: (controller) => mapController = controller,
                  markers: picked == null
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId("picked"),
                            position: picked!,
                          )
                        },
                  onTap: (pos) {
                    setState(() => picked = pos);
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: ElevatedButton.icon(
                      onPressed: picked != null
                          ? () {
                              widget.onPicked(picked!);
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF875AA),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFFF875AA).withOpacity(0.6),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 26, color: Colors.white),
                      label: const Text(
                        "Pilih Lokasi",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
