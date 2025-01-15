import 'package:flutter/material.dart';
import '../models/docker_service.dart';

class ServiceBox extends StatefulWidget {
  final DockerService service;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const ServiceBox({
    super.key,
    required this.service,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  _ServiceBoxState createState() => _ServiceBoxState();
}

class _ServiceBoxState extends State<ServiceBox> {
  bool isExpanded = false;
  final _formKey = GlobalKey<FormState>();

  void _notifyChange() {
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ListTile(
              title: TextField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  widget.service.name = value;
                  _notifyChange();
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () => setState(() => isExpanded = !isExpanded),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              _buildSection('Basic Configuration', [
                _buildTextField('Image', (v) {
                  widget.service.image = v;
                  _notifyChange();
                }),
                _buildTextField('Command', (v) {
                  widget.service.command = v;
                  _notifyChange();
                }),
                _buildTextField('Working Directory', (v) {
                  widget.service.workingDir = v;
                  _notifyChange();
                }),
              ]),
              _buildSection('Environment', [
                _buildMapEditor(
                  widget.service.environment,
                  'Environment Variables',
                  'Variable',
                  'Value',
                ),
              ]),
              _buildSection('Networking', [
                _buildListEditor(widget.service.ports, 'Ports'),
                _buildMapEditor(widget.service.networks, 'Networks', 'Network', 'Config'),
              ]),
              _buildSection('Storage', [
                _buildListEditor(widget.service.volumes, 'Volumes'),
              ]),
              _buildSection('Advanced', [
                _buildDropdown('Restart Policy', widget.service.restart, [
                  'no',
                  'always',
                  'on-failure',
                  'unless-stopped',
                ], (v) {
                  widget.service.restart = v;
                  _notifyChange();
                }),
                _buildMapEditor(widget.service.deploy, 'Deploy Config', 'Key', 'Value'),
                _buildListEditor(widget.service.depends_on, 'Depends On'),
              ]),
              _buildSection('Container Settings', [
                _buildTextField('Container Name', (v) {
                  widget.service.container_name = v;
                  _notifyChange();
                }),
                _buildTextField('User', (v) {
                  widget.service.user = v;
                  _notifyChange();
                }),
                _buildBooleanSwitch('TTY', widget.service.tty ?? false, (v) {
                  widget.service.tty = v;
                  _notifyChange();
                }),
                _buildBooleanSwitch('Init', widget.service.init ?? false, (v) {
                  widget.service.init = v;
                  _notifyChange();
                }),
              ]),
              _buildSection('Resource Limits', [
                _buildMapEditor(widget.service.ulimits, 'Ulimits', 'Limit Name', 'Value'),
                _buildTextField('Shared Memory Size', (v) {
                  widget.service.shm_size = v;
                  _notifyChange();
                }),
              ]),
              _buildSection('Security', [
                _buildMapEditor(widget.service.security_opt, 'Security Options', 'Option', 'Value'),
                _buildMapEditor(widget.service.sysctls, 'Sysctls', 'Option', 'Value'),
                _buildListEditor(widget.service.cap_add, 'Capabilities Add'),
                _buildListEditor(widget.service.cap_drop, 'Capabilities Drop'),
                _buildBooleanSwitch('Privileged', widget.service.privileged ?? false, (v) {
                  widget.service.privileged = v;
                  _notifyChange();
                }),
              ]),
              _buildSection('Lifecycle', [
                _buildTextField('Stop Grace Period', (v) {
                  widget.service.stop_grace_period = v;
                  _notifyChange();
                }),
                _buildTextField('Stop Signal', (v) {
                  widget.service.stop_signal = v;
                  _notifyChange();
                }),
              ]),
              _buildSection('Additional Configuration', [
                _buildMapEditor(widget.service.logging, 'Logging', 'Option', 'Value'),
                _buildMapEditor(widget.service.configs, 'Configs', 'Config', 'Value'),
                _buildMapEditor(widget.service.devices, 'Devices', 'Path', 'Permission'),
                _buildTextField('PID', (v) {
                  widget.service.pid = v;
                  _notifyChange();
                }),
                _buildTextField('Tmpfs', (v) {
                  widget.service.tmpfs = v;
                  _notifyChange();
                }),
                _buildListEditor(widget.service.expose, 'Expose Ports'),
              ]),
              _buildSection('Build Configuration', [
                _buildMapEditor(widget.service.build, 'Build', 'Option', 'Value'),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        ),
        onChanged: (value) {
          onChanged(value);
          _notifyChange();
        },
      ),
    );
  }

  Widget _buildListEditor(List<String> items, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        ListView.builder(
          shrinkWrap: true,
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == items.length) {
              return IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    items.add('');
                    _notifyChange();
                  });
                },
              );
            }
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '$label ${index + 1}',
                    ),
                    onChanged: (value) {
                      setState(() {
                        items[index] = value;
                        _notifyChange();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      items.removeAt(index);
                      _notifyChange();
                    });
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
            _notifyChange();
          }
        },
      ),
    );
  }

  Widget _buildMapEditor(Map<String, dynamic> map, String label, String keyLabel, String valueLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        ListView.builder(
          shrinkWrap: true,
          itemCount: map.length + 1,
          itemBuilder: (context, index) {
            if (index == map.length) {
              return IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    map[''] = '';
                    _notifyChange();
                  });
                },
              );
            }
            String key = map.keys.elementAt(index);
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: keyLabel),
                    controller: TextEditingController(text: key),
                    onChanged: (newKey) {
                      setState(() {
                        var value = map[key];
                        map.remove(key);
                        map[newKey] = value;
                        _notifyChange();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: valueLabel),
                    controller: TextEditingController(text: map[key].toString()),
                    onChanged: (value) {
                      setState(() {
                        map[key] = value;
                        _notifyChange();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      map.remove(key);
                      _notifyChange();
                    });
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBooleanSwitch(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                onChanged(newValue);
              });
            },
          ),
        ],
      ),
    );
  }
}
