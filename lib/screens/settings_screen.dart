import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'Layout',
            [
              SwitchListTile(
                title: const Text('Show YAML Preview'),
                subtitle: const Text('Display real-time YAML on the right side'),
                value: settings.showYamlPreview,
                onChanged: (bool value) => context.read<AppSettings>().setShowYamlPreview(value),
              ),
              SwitchListTile(
                title: const Text('Show Version'),
                subtitle: const Text('Display docker-compose version in editor'),
                value: settings.showVersion,
                onChanged: (bool value) => context.read<AppSettings>().setShowVersion(value),
              ),
            ],
          ),
          _buildSection(
            context,
            'Editor',
            [
              SwitchListTile(
                title: const Text('Auto-Save'),
                subtitle: const Text('Automatically save changes'),
                value: settings.autoSave,
                onChanged: (bool value) => context.read<AppSettings>().setAutoSave(value),
              ),
              ListTile(
                title: const Text('Default Docker Compose Version'),
                subtitle: const Text('Select the default version for new files'),
                trailing: DropdownButton<String>(
                  value: settings.defaultVersion,
                  items: ['2', '2.1', '3', '3.1', '3.8'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      context.read<AppSettings>().setDefaultVersion(value);
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            'Appearance',
            [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark color scheme'),
                value: settings.isDarkMode,
                onChanged: (bool value) => context.read<AppSettings>().setIsDarkMode(value),
              ),
              ListTile(
                title: const Text('Font Size'),
                subtitle: const Text('Adjust the editor font size'),
                trailing: DropdownButton<double>(
                  value: settings.fontSize,
                  items: [12.0, 14.0, 16.0, 18.0].map((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (double? value) {
                    if (value != null) {
                      context.read<AppSettings>().setFontSize(value);
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            context,
            'Advanced',
            [
              SwitchListTile(
                title: const Text('Enable Experimental Features'),
                subtitle: const Text('Access beta features'),
                value: settings.experimentalFeatures,
                onChanged: (bool value) => context.read<AppSettings>().setExperimentalFeatures(value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}
