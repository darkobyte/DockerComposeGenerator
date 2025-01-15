import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yaml/yaml.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../widgets/service_box.dart';
import '../models/docker_service.dart';
import '../widgets/yaml_editor.dart';
import 'settings_screen.dart';
import '../models/app_settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DockerService> services = [];
  bool _hasYamlError = false;
  String _errorMessage = '';

  String _jsonToYaml(Map<String, dynamic> json) {
    String yaml = '';
    
    if (json.containsKey('version')) {
      yaml += 'version: "${json['version']}"\n';
    }
    
    yaml += 'services:\n';
    
    if (json['services'] != null) {
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
    }
    
    return yaml;
  }

  Map<String, dynamic> _yamlToJson(String yamlString) {
    try {
      final yamlDoc = loadYaml(yamlString);
      Map<String, dynamic> jsonData = {};
      
      if (yamlDoc is YamlMap) {
        jsonData = _convertYamlToMap(yamlDoc);
      } else {
        throw 'Invalid YAML structure: document root must be a map';
      }
      
      return jsonData;
    } catch (e) {
      throw 'Invalid YAML format: ${e.toString()}';
    }
  }

  Map<String, dynamic> _convertYamlToMap(YamlMap yamlMap) {
    Map<String, dynamic> result = {};
    
    yamlMap.forEach((key, value) {
      if (value is YamlMap) {
        result[key.toString()] = _convertYamlToMap(value);
      } else if (value is YamlList) {
        result[key.toString()] = value.map((item) => item.toString()).toList();
      } else {
        result[key.toString()] = value;
      }
    });
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final bool showPreview = settings.showYamlPreview;
    final bool showVersion = settings.showVersion;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Docker Compose Creator'),
        actions: [
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side - Visual Editor
          Expanded(
            flex: showPreview ? 1 : 2,
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _hasYamlError ? 0.3 : 1.0,
                  child: IgnorePointer(
                    ignoring: _hasYamlError,
                    child: services.isEmpty
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
                                onChanged: _updateYamlFromServices,
                              );
                            },
                          ),
                  ),
                ),
                if (services.isNotEmpty)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: _addService,
                      child: const Icon(Icons.add),
                    ),
                  ),
              ],
            ),
          ),
          // Right side - YAML Editor (conditional)
          if (showPreview)
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: YamlEditor(
                      initialValue: _getServicesYaml(settings.showVersion),
                      onChanged: (_) {}, // No-op since editor is read-only
                      hasError: _hasYamlError,
                      fontSize: settings.fontSize,
                    ),
                  ),
                  if (_hasYamlError)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Material(
                        elevation: 8,
                        color: Theme.of(context).colorScheme.error,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _hasYamlError = false;
                                    _errorMessage = '';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getServicesYaml(bool showVersion) {
    final settings = context.read<AppSettings>();
    final composeData = <String, dynamic>{};
    
    if (showVersion) {
      composeData['version'] = settings.defaultVersion;
    }
    
    composeData['services'] = {
      for (var service in services)
        if (service.name.isNotEmpty)
          service.name: service.toJson()
    };

    return _jsonToYaml(composeData);
  }

  void _updateServicesFromYaml(String yamlContent) {
    try {
      final data = _yamlToJson(yamlContent);
      if (data['services'] == null) {
        throw 'Invalid docker-compose file format';
      }

      setState(() {
        services.clear();
        (data['services'] as Map).forEach((key, value) {
          if (value is Map<String, dynamic>) {
            final service = DockerService.fromJson(value);
            service.name = key.toString();
            services.add(service);
          }
        });
        _hasYamlError = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _hasYamlError = true;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  void _updateYamlFromServices() {
    setState(() {}); // This will trigger a rebuild and update the YAML
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
}
