import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _takenPicture;
  PlaceLocation? _selectedLocation;

  void _registerPlace() {
    final eneteredName = _titleController.text;

    if (eneteredName.isEmpty || _takenPicture == null || _selectedLocation == null) {
      return;
    }

    ref
        .read(placesProvider.notifier)
        .addNewPlace(name: eneteredName, image: _takenPicture!,location: _selectedLocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new place')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 10),
            ImageInput(onPictureTaken: (img) => _takenPicture = img),
            const SizedBox(height: 10),
            LocationInput(onSelectLocation: (location) {
              _selectedLocation = location;
            }),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _registerPlace,
              label: Text('Add'),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
