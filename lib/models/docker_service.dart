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
    return service;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name.isNotEmpty) data['name'] = name;
    if (image.isNotEmpty) data['image'] = image;
    if (environment.isNotEmpty) data['environment'] = environment;
    if (ports.isNotEmpty) data['ports'] = ports;
    if (volumes.isNotEmpty) data['volumes'] = volumes;
    if (labels.isNotEmpty) data['labels'] = labels;
    if (command != null) data['command'] = command;
    if (depends_on.isNotEmpty) data['depends_on'] = depends_on;
    if (restart != 'no') data['restart'] = restart;
    if (networks.isNotEmpty) data['networks'] = networks;
    if (deploy.isNotEmpty) data['deploy'] = deploy;
    if (workingDir != null) data['working_dir'] = workingDir;
    if (entrypoint.isNotEmpty) data['entrypoint'] = entrypoint;
    if (healthcheck.isNotEmpty) data['healthcheck'] = healthcheck;
    if (privileged != null) data['privileged'] = privileged;
    if (dns.isNotEmpty) data['dns'] = dns;
    if (secrets.isNotEmpty) data['secrets'] = secrets;

    return data;
  }
}
