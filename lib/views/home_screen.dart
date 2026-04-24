import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/billboard_controller.dart';
import '../core/theme.dart';
import 'census_form.dart';
import 'map_screen.dart';
import 'billboard_list_screen.dart';
import '../services/export_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillboardController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PanneauxMapr - Maroua'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => controller.fetchBillboards(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildStatsCard(controller),
            const SizedBox(height: 24),
            const Text(
              'Actions Rapides',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildQuickActions(context, controller),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const CensusForm()),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Nouveau Recensement'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.map, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Bienvenue sur PanneauxMapr',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Recensement des panneaux à Maroua',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BillboardController controller) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', '${controller.billboards.length}', Icons.bar_chart),
              _buildVerticalDivider(),
              _buildStatItem('Aujourd\'hui', '0', Icons.today),
              _buildVerticalDivider(),
              _buildStatItem('Exportés', '0', Icons.file_upload),
            ],
          ),
        ));
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildQuickActions(BuildContext context, BillboardController controller) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildActionCard(
          'Carte Interactive',
          Icons.map_outlined,
          AppColors.primary,
          () => Get.to(() => const MapScreen()),
        ),
        _buildActionCard(
          'Liste des Panneaux',
          Icons.list_alt,
          AppColors.secondary,
          () => Get.to(() => const BillboardListScreen()),
        ),
        _buildActionCard(
          'Exporter Données',
          Icons.download,
          AppColors.accent,
          () => _showExportOptions(context, controller),
        ),
        _buildActionCard(
          'Paramètres',
          Icons.settings,
          Colors.blueGrey,
          () => Get.snackbar('Paramètres', 'En développement'),
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportOptions(BuildContext context, BillboardController controller) {
    if (controller.billboards.isEmpty) {
      Get.snackbar('Export', 'Aucune donnée à exporter');
      return;
    }

    final exportService = ExportService();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choisir le format d\'export',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Format CSV (Excel)'),
              subtitle: const Text('Idéal pour l\'analyse statistique'),
              onTap: () {
                Get.back();
                exportService.exportToCSV(controller.billboards);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.public, color: Colors.blue),
              title: const Text('Format GeoJSON (SIG)'),
              subtitle: const Text('Idéal pour QGIS, ArcGIS, etc.'),
              onTap: () {
                Get.back();
                exportService.exportToGeoJSON(controller.billboards);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
