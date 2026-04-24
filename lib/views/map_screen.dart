import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../controllers/billboard_controller.dart';
import '../data/models/billboard.dart';
import '../core/theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillboardController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Carte des Panneaux')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(10.5916, 14.3158), // Maroua, Cameroon
            initialZoom: 13,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.panneau',
              tileProvider: NetworkTileProvider(),
            ),
            MarkerLayer(
              markers: controller.billboards.map((b) => _buildMarker(context, b)).toList(),
            ),
          ],
        );
      }),
    );
  }

  Marker _buildMarker(BuildContext context, Billboard billboard) {
    return Marker(
      point: LatLng(billboard.latitude, billboard.longitude),
      width: 60,
      height: 60,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () => _showBillboardDetails(context, billboard),
        child: _BillboardMarkerIcon(type: billboard.type),
      ),
    );
  }

  void _showBillboardDetails(BuildContext context, Billboard billboard) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  billboard.type,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(billboard.photoPath),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${billboard.description}'),
                      const SizedBox(height: 4),
                      Text('Dimensions: ${billboard.dimension}'),
                      const SizedBox(height: 4),
                      Text('État: ${billboard.condition}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BillboardMarkerIcon extends StatelessWidget {
  final String type;

  const _BillboardMarkerIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    bool isDigital = type == 'Numérique';
    Color boardColor = isDigital ? Colors.black : Colors.white;
    Color borderColor = isDigital ? AppColors.secondary : Colors.grey[700]!;

    return Column(
      children: [
        // The Board
        Container(
          width: 45,
          height: 30,
          decoration: BoxDecoration(
            color: boardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isDigital
              ? Center(
                  child: Container(
                    width: 35,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withValues(alpha: 0.2),
                          Colors.blue.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: const Icon(Icons.flash_on, size: 12, color: Colors.blue),
                  ),
                )
              : Center(
                  child: Icon(Icons.image, size: 16, color: Colors.grey[400]),
                ),
        ),
        // The Pole
        Container(
          width: 4,
          height: 20,
          color: Colors.grey[600],
        ),
        // The Base
        Container(
          width: 10,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
