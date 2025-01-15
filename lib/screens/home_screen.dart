import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yaml/yaml.dart';
import 'dart:convert';
import '../widgets/service_box.dart';
import '../models/docker_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DockerService> services = [];

  String _jsonToYaml(Map<String, dynamic> json) {
    // Convert Map to YAML string
    String yaml = 'version: "3"\nservices:\n';
    
    json['services'].forEach((serviceName, serviceData) {
      yaml += '  $serviceName:\n';
      (serviceData as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          yaml += '    $key:\n';
          for (var item in value) {
            yaml += '      - $item\n';
          }
        } else if (value is Map) {
          yaml += '    $key:\n';
          value.forEach((k, v) {
            yaml += '      $k: $v\n';
          });
        } else {
          yaml += '    $key: $value\n';
        }
      });
    });
    
    return yaml;
  }

  Map<String, dynamic> _yamlToJson(String yamlString) {
    // Parse YAML string to Map
    final yamlDoc = loadYaml(yamlString);
    return json.decode(json.encode(yamlDoc));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Docker Compose Creator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _importCompose,
            tooltip: 'Import Docker Compose',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportCompose,
            tooltip: 'Export Docker Compose',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Docker Compose Creator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Service'),
              onTap: () {
                Navigator.pop(context);
                _addService();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Implement settings
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: services.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add a service to get started',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addService,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Service'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return ServiceBox(
                  service: services[index],
                  onDelete: () => _deleteService(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addService,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addService() {
    setState(() {
      services.add(DockerService());
    });
  }

  void _deleteService(int index) {
    setState(() {
      services.removeAt(index);
    });
  }

  Future<void> _exportCompose() async {
    if (services.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one service first')),
      );
      return;
    }

    final composeData = {
      'services': {
        for (var service in services)
          if (service.name.isNotEmpty)
            service.name: service.toJson()
      }
    };

    if (composeData['services']?.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a name to at least one service')),
      );
      return;
    }

    final yaml = _jsonToYaml(composeData);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Docker Compose File'),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              yaml,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: yaml));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  Future<void> _importCompose() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['yml', 'yaml'],
      );

      if (result != null) {
        final contents = utf8.decode(result.files.first.bytes!);
        final data = _yamlToJson(contents);
        
        if (data['services'] == null) {
          throw 'Invalid docker-compose file format';
        }

        setState(() {
          services.clear();
          (data['services'] as Map).forEach((key, value) {
            final service = DockerService.fromJson(value as Map<String, dynamic>);
            service.name = key as String;
            services.add(service);
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Docker Compose file imported successfully')),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to import file: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
