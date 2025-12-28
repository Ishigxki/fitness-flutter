import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/run_path_model.dart';

class ReplayMapScreen extends StatelessWidget {
  final RunPath run;
  const ReplayMapScreen({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final pts = run.points;
    return Scaffold(
      appBar: AppBar(
        title: Text('Run on ${run.timestamp.toLocal().toString().split('.')[0]}'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: pts.isNotEmpty ? pts.first : LatLng(0, 0),
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.fitquest',
          ),
          if (pts.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: pts,
                  strokeWidth: 4.0,
                  color: Colors.green,
                )
              ],
            ),
        ],
      ),
    );
  }
}
