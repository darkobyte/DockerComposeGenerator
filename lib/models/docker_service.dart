class DockerService {
  String name = '';
  String image = '';
  Map<String, String> environment = {};
  List<String> ports = [];
  List<String> volumes = [];
  Map<String, String> labels = {};
  String? command;
  List<String> depends_on = [];
  String restart = 'no';
  Map<String, String> networks = {};
  Map<String, String> deploy = {};
  String? workingDir;
  List<String> entrypoint = [];
  Map<String, String> healthcheck = {};
  bool? privileged;
  List<String> dns = [];
  Map<String, String> secrets = {};

  // Additional properties
  Map<String, String> ulimits = {};
  String? user;
  Map<String, String> configs = {};
  List<String> expose = [];
  String? container_name;
  bool? init;
  Map<String, String> logging = {};
  String? pid;
  Map<String, String> security_opt = {};
  Map<String, String> sysctls = {};
  List<String> cap_add = [];
  List<String> cap_drop = [];
  Map<String, String> devices = {};
  String? stop_grace_period;
  String? stop_signal;
  String? tmpfs;
  bool? tty;
  String? shm_size;
  Map<String, String> build = {};

  static DockerService fromJson(Map<String, dynamic> json) {
    final service = DockerService();
    service.name = json['name'] ?? '';
    service.image = json['image'] ?? '';
    service.environment = Map<String, String>.from(json['environment'] ?? {});
    service.ports = List<String>.from(json['ports'] ?? []);
    service.volumes = List<String>.from(json['volumes'] ?? []);
    service.labels = Map<String, String>.from(json['labels'] ?? {});
    service.command = json['command'];
    service.depends_on = List<String>.from(json['depends_on'] ?? []);
    service.restart = json['restart'] ?? 'no';
    service.networks = Map<String, String>.from(json['networks'] ?? {});
    service.deploy = Map<String, String>.from(json['deploy'] ?? {});
    service.workingDir = json['working_dir'];
    service.entrypoint = List<String>.from(json['entrypoint'] ?? []);
    service.healthcheck = Map<String, String>.from(json['healthcheck'] ?? {});
    service.privileged = json['privileged'];
    service.dns = List<String>.from(json['dns'] ?? []);
    service.secrets = Map<String, String>.from(json['secrets'] ?? {});

    // Add new properties
    service.ulimits = Map<String, String>.from(json['ulimits'] ?? {});
    service.user = json['user'];
    service.configs = Map<String, String>.from(json['configs'] ?? {});
    service.expose = List<String>.from(json['expose'] ?? []);
    service.container_name = json['container_name'];
    service.init = json['init'];
    service.logging = Map<String, String>.from(json['logging'] ?? {});
    service.pid = json['pid'];
    service.security_opt = Map<String, String>.from(json['security_opt'] ?? {});
    service.sysctls = Map<String, String>.from(json['sysctls'] ?? {});
    service.cap_add = List<String>.from(json['cap_add'] ?? []);
    service.cap_drop = List<String>.from(json['cap_drop'] ?? []);
    service.devices = Map<String, String>.from(json['devices'] ?? {});
    service.stop_grace_period = json['stop_grace_period'];
    service.stop_signal = json['stop_signal'];
    service.tmpfs = json['tmpfs'];
    service.tty = json['tty'];
    service.shm_size = json['shm_size'];
    service.build = Map<String, String>.from(json['build'] ?? {});
    return service;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    void addIfNotEmpty(String key, dynamic value) {
      if (value != null) {
        if (value is String && value.isNotEmpty) {
          data[key] = value;
        } else if (value is List && value.isNotEmpty) {
          data[key] = value;
        } else if (value is Map && value.isNotEmpty) {
          data[key] = value;
        } else if (value is bool) {
          data[key] = value;
        }
      }
    }

    addIfNotEmpty('name', name);
    addIfNotEmpty('image', image);
    addIfNotEmpty('environment', environment);
    addIfNotEmpty('ports', ports);
    addIfNotEmpty('volumes', volumes);
    addIfNotEmpty('labels', labels);
    addIfNotEmpty('command', command);
    addIfNotEmpty('depends_on', depends_on);
    addIfNotEmpty('restart', restart != 'no' ? restart : null);
    addIfNotEmpty('networks', networks);
    addIfNotEmpty('deploy', deploy);
    addIfNotEmpty('working_dir', workingDir);
    addIfNotEmpty('entrypoint', entrypoint);
    addIfNotEmpty('healthcheck', healthcheck);
    addIfNotEmpty('privileged', privileged);
    addIfNotEmpty('dns', dns);
    addIfNotEmpty('secrets', secrets);

    // Add new properties to output
    addIfNotEmpty('ulimits', ulimits);
    addIfNotEmpty('user', user);
    addIfNotEmpty('configs', configs);
    addIfNotEmpty('expose', expose);
    addIfNotEmpty('container_name', container_name);
    addIfNotEmpty('init', init);
    addIfNotEmpty('logging', logging);
    addIfNotEmpty('pid', pid);
    addIfNotEmpty('security_opt', security_opt);
    addIfNotEmpty('sysctls', sysctls);
    addIfNotEmpty('cap_add', cap_add);
    addIfNotEmpty('cap_drop', cap_drop);
    addIfNotEmpty('devices', devices);
    addIfNotEmpty('stop_grace_period', stop_grace_period);
    addIfNotEmpty('stop_signal', stop_signal);
    addIfNotEmpty('tmpfs', tmpfs);
    addIfNotEmpty('tty', tty);
    addIfNotEmpty('shm_size', shm_size);
    addIfNotEmpty('build', build);

    return data;
  }
}
