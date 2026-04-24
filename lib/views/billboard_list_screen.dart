import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/billboard_controller.dart';
import '../data/models/billboard.dart';
import '../core/theme.dart';

class BillboardListScreen extends StatelessWidget {
  const BillboardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillboardController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Panneaux')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.billboards.isEmpty) {
          return const Center(
            child: Text('Aucun panneau recensé pour le moment'),
          );
        }

        return ListView.builder(
          itemCount: controller.billboards.length,
          itemBuilder: (context, index) {
            final billboard = controller.billboards[index];
            return _buildBillboardTile(billboard, controller);
          },
        );
      }),
    );
  }

  Widget _buildBillboardTile(Billboard billboard, BillboardController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(billboard.photoPath),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          billboard.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${billboard.type} - ${billboard.dimension}'),
            Text(
              'Lat: ${billboard.latitude.toStringAsFixed(4)}, Lon: ${billboard.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () => _confirmDelete(billboard, controller),
        ),
      ),
    );
  }

  void _confirmDelete(Billboard billboard, BillboardController controller) {
    Get.defaultDialog(
      title: 'Suppression',
      middleText: 'Voulez-vous vraiment supprimer ce panneau ?',
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        controller.deleteBillboard(billboard.id!);
        Get.back();
      },
    );
  }
}
