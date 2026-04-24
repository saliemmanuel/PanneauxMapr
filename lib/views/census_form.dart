import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/billboard_controller.dart';
import '../data/models/billboard.dart';
import '../services/location_service.dart';
import '../services/camera_service.dart';

class CensusForm extends StatefulWidget {
  const CensusForm({super.key});

  @override
  State<CensusForm> createState() => _CensusFormState();
}

class _CensusFormState extends State<CensusForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _dimensionController = TextEditingController();

  String _selectedType = 'Statique';
  String _selectedCondition = 'Bon état';
  XFile? _image;
  double? _latitude;
  double? _longitude;
  bool _isLoadingLocation = false;

  final _locationService = LocationService();
  final _cameraService = CameraService();
  final _billboardController = Get.find<BillboardController>();

  final List<String> _types = [
    'Statique',
    'Numérique',
    'Lumineux',
    'Unipole',
    'Autre',
  ];
  final List<String> _conditions = [
    'Bon état',
    'Passable',
    'Endommagé',
    'À remplacer',
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }
    } catch (e) {
      Get.snackbar('Erreur Localisation', e.toString());
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _takePhoto() async {
    final image = await _cameraService.takePhoto();
    if (image != null) {
      setState(() => _image = image);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      Get.snackbar('Erreur', 'Veuillez prendre une photo du panneau');
      return;
    }
    if (_latitude == null || _longitude == null) {
      Get.snackbar('Erreur', 'Localisation GPS requise');
      return;
    }

    final billboard = Billboard(
      latitude: _latitude!,
      longitude: _longitude!,
      photoPath: _image!.path,
      description: _descriptionController.text,
      type: _selectedType,
      dimension: _dimensionController.text,
      condition: _selectedCondition,
      dateAdded: DateTime.now().toIso8601String(),
    );

    await _billboardController.addBillboard(billboard);
    Get.back();
    Get.snackbar('Succès', 'Panneau enregistré avec succès');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau Recensement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationStatus(),
              const SizedBox(height: 20),
              _buildPhotoSection(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description / Emplacement',
                  hintText: 'Ex: Carrefour Total, face au marché',
                ),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: _types
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedType = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _dimensionController,
                      decoration: const InputDecoration(
                        labelText: 'Dimensions',
                        hintText: 'Ex: 4x3m',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(labelText: 'État du panneau'),
                items: _conditions
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCondition = v!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enregistrer le Panneau'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _latitude != null
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _latitude != null ? Colors.green : Colors.orange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _latitude != null ? Icons.location_on : Icons.location_searching,
            color: _latitude != null ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _latitude != null
                      ? 'Localisation GPS acquise'
                      : 'Recherche de position GPS...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _latitude != null ? Colors.green : Colors.orange,
                  ),
                ),
                if (_latitude != null)
                  Text(
                    'Lat: ${_latitude!.toStringAsFixed(6)}, Lon: ${_longitude!.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
          if (_isLoadingLocation)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          if (!_isLoadingLocation)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _getLocation,
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _takePhoto,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Prendre une photo du panneau',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(_image!.path), fit: BoxFit.cover),
              ),
      ),
    );
  }
}
