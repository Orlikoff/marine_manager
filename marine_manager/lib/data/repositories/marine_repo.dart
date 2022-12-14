import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import '../../credentials.dart';
import '../entities/container.dart';
import '../entities/port.dart';
import '../entities/vessel.dart';
import '../abstractions/data_provider.dart';
import '../entities/route.dart';

class MarineRepo {
  late final DataProvider dataProvider;

  static final MarineRepo _instance = MarineRepo._internal();

  MarineRepo._internal();

  static void init(DataProvider initDataProvider) {
    _instance.dataProvider = initDataProvider;
  }

  factory MarineRepo.instance() {
    return _instance;
  }

  // Functions of repository
  Future<void> removeRoute(dynamic id) async {
    await dataProvider
        .loadQueryResults('DELETE FROM route WHERE id=@i', subValues: {
      'i': id,
    });
  }

  Future<void> createLinkedPorts({
    required dynamic routeId,
    required List<PortData> portsLinked,
  }) async {
    for (var port in portsLinked) {
      await createPortRoute(portId: port.id, routeId: routeId);
    }
  }

  Future<void> createPortRoute({
    required dynamic portId,
    required dynamic routeId,
  }) async {
    await dataProvider.loadQueryResults(
        'INSERT INTO port_route(port_id, route_id)'
        'VALUES (@p, @r);',
        subValues: {
          'p': portId,
          'r': routeId,
        });
  }

  Future<dynamic> createRoute({
    required dynamic shipmentCompany,
    required dynamic routeVesselCode,
  }) async {
    await dataProvider.loadQueryResults(
        'INSERT INTO route(marine_worker_id, shipment_company, route_vessel_code)'
        'VALUES (@m, @s, @r);',
        subValues: {
          'm': credentials!['marine_worker_id'],
          's': shipmentCompany,
          'r': routeVesselCode,
        });

    var data = await dataProvider.loadQueryResults(
        'SELECT id FROM route WHERE route_vessel_code=@r',
        subValues: {
          'r': routeVesselCode,
        });

    dynamic id;

    for (final row in data) {
      id = row['route']!['id'];
    }

    return id;
  }

  Future<List<RouteData>> loadRoutes() async {
    List<RouteData> routes = [];

    var data = await dataProvider.loadQueryResults(
        'SELECT id, marine_worker_id, shipment_company, route_vessel_code FROM route;');

    for (final row in data) {
      routes.add(
        RouteData(
          id: row['route']!['id'],
          marineWorkerId: row['route']!['marine_worker_id'],
          shipmentCompany: row['route']!['shipment_company'],
          routeVesselCode: row['route']!['route_vessel_code'],
        ),
      );
    }

    return routes;
  }

  Future<void> createShip({
    required dynamic routeId,
    required dynamic vesselVerboseName,
    required dynamic countryOfOrigin,
    required dynamic maxLoadCapacity,
  }) async {
    if (routeId == null) {
      await dataProvider.loadQueryResults(
          'INSERT INTO vessel(marine_worker_id, vessel_verbose_name, country_of_origin, max_load_capacity)'
          'VALUES (@mid, @v, @c, @m);',
          subValues: {
            'mid': credentials!['marine_worker_id'],
            'v': vesselVerboseName,
            'c': countryOfOrigin,
            'm': maxLoadCapacity.toString(),
          });
    } else {
      await dataProvider.loadQueryResults(
          'INSERT INTO vessel(route_id, marine_worker_id, vessel_verbose_name, country_of_origin, max_load_capacity)'
          'VALUES (@r, @mid, @v, @c, @m);',
          subValues: {
            'r': routeId,
            'mid': credentials!['marine_worker_id'],
            'v': vesselVerboseName,
            'c': countryOfOrigin,
            'm': maxLoadCapacity,
          });
    }
  }

  Future<void> removeShip(dynamic id) async {
    await dataProvider
        .loadQueryResults('DELETE FROM vessel WHERE id=@i', subValues: {
      'i': id,
    });
  }

  Future<void> createContainer({
    required dynamic dispPortId,
    required dynamic destPortId,
    required dynamic vesselId,
    required dynamic code,
  }) async {
    if (vesselId == null && destPortId == null) {
      await dataProvider.loadQueryResults(
          'INSERT INTO container(dispatch_port_id, container_code)'
          'VALUES (@d, @c);',
          subValues: {
            'd': dispPortId,
            'c': code,
          });
      return;
    } else if (vesselId == null) {
      await dataProvider.loadQueryResults(
          'INSERT INTO container(dispatch_port_id, destination_port_id, container_code)'
          'VALUES (@d, @des, @c);',
          subValues: {
            'd': dispPortId,
            'c': code,
            'des': destPortId,
          });
      return;
    } else if (destPortId == null) {
      await dataProvider.loadQueryResults(
          'INSERT INTO container(dispatch_port_id, vessel_id, container_code)'
          'VALUES (@d, @v, @c);',
          subValues: {
            'd': dispPortId,
            'c': code,
            'v': vesselId,
          });
      return;
    } else {
      await dataProvider.loadQueryResults(
          'INSERT INTO container(dispatch_port_id, destination_port_id, vessel_id, container_code)'
          'VALUES (@d, @des, @v, @c);',
          subValues: {
            'd': dispPortId,
            'c': code,
            'des': destPortId,
            'v': vesselId,
          });
      return;
    }
  }

  Future<List<PortData>> loadPorts() async {
    List<PortData> ports = [];

    var data = await dataProvider.loadQueryResults(
        'SELECT id, marine_worker_id, port_name, port_unified_code, port_country, max_containers_capacity FROM port;');

    for (final row in data) {
      ports.add(
        PortData(
          id: row['port']!['id'],
          marineWorkerId: row['port']!['marine_worker_id'],
          portName: row['port']!['port_name'],
          portUnifiedCode: row['port']!['port_unified_code'],
          portCountry: row['port']!['port_country'],
          maxContainersCapacity: row['port']!['max_containers_capacity'],
        ),
      );
    }

    return ports;
  }

  Future<List<VesselData>> loadShips() async {
    List<VesselData> ships = [];

    var data = await dataProvider.loadQueryResults(
        'SELECT id, route_id, marine_worker_id, vessel_verbose_name, country_of_origin, max_load_capacity FROM vessel;');

    for (final row in data) {
      ships.add(
        VesselData(
          id: row['vessel']!['id'],
          routeId: row['vessel']!['route_id'],
          marineWorkerId: row['vessel']!['marine_worker_id'],
          vesselVerboseName: row['vessel']!['vessel_verbose_name'],
          countryOfOrigin: row['vessel']!['country_of_origin'],
          maxLoadCapacity: row['vessel']!['max_load_capacity'],
        ),
      );
    }

    return ships;
  }

  Future<void> removeContainer(dynamic id) async {
    await dataProvider
        .loadQueryResults('DELETE FROM container WHERE id=@i', subValues: {
      'i': id,
    });
  }

  Future<List<ContainerData>> loadContainers() async {
    List<ContainerData> containers = [];
    var data = await dataProvider.loadQueryResults(
        'SELECT id, dispatch_port_id, destination_port_id, vessel_id, container_code FROM container;');

    for (final row in data) {
      containers.add(
        ContainerData(
          id: row['container']!['id'],
          dispatchPortId: row['container']!['dispatch_port_id'],
          destinationPortId: row['container']!['destination_port_id'],
          vesselId: row['container']!['vessel_id'],
          containerCode: row['container']!['container_code'],
        ),
      );
    }

    return containers;
  }

  Future<List<List<dynamic>>> loadUsernames() async {
    final List<List<dynamic>> usernamesById = [];
    var data = await dataProvider.loadQueryResults(
        'SELECT id, user_name FROM user_data ORDER BY id ASC;');

    for (final row in data) {
      usernamesById.add([
        row['user_data']!['id'],
        row['user_data']!['user_name'].toString(),
      ]);
    }

    return usernamesById;
  }

  Future<void> changeUsername(int index, String newUsername) async {
    await dataProvider.loadQueryResults(
      'UPDATE user_data SET user_name=@u WHERE id=@i;',
      subValues: {
        'u': newUsername,
        'i': index,
      },
    );
  }

  // Account page functions
  Future<Map<String, dynamic>?> authenticateUser(
    String email,
    String password, {
    VoidCallback? onWrongCreds,
  }) async {
    final Map<String, dynamic> userCredentials = {};
    var data = await dataProvider.loadQueryResults(
        'SELECT * FROM user_data WHERE user_email=@e AND user_password=@p;',
        subValues: {
          'e': email,
          'p': password,
        });

    if (data.isNotEmpty) {
      for (final row in data) {
        var tableData = row['user_data']!;
        userCredentials['id'] = tableData['id'];
        userCredentials['user_name'] = tableData['user_name'];
        userCredentials['user_surname'] = tableData['user_surname'];
        userCredentials['user_email'] = tableData['user_email'];
        userCredentials['user_password'] = tableData['user_password'];
      }

      data = await dataProvider.loadQueryResults(
          "SELECT * FROM app_user WHERE user_data_id=@i AND user_role='worker';",
          subValues: {
            'i': userCredentials['id'],
          });

      if (data.isNotEmpty) {
        for (final row in data) {
          var tableData = row['app_user']!;
          userCredentials['user_role'] = tableData['user_role'];
          userCredentials['marine_worker_id'] = tableData['marine_worker_id'];
        }

        data = await dataProvider.loadQueryResults(
            "SELECT * FROM marine_worker WHERE id=@i;",
            subValues: {
              'i': userCredentials['marine_worker_id'],
            });

        if (data.isNotEmpty) {
          for (final row in data) {
            var tableData = row['marine_worker']!;
            userCredentials['company_name'] = tableData['company_name'];
            userCredentials['country_of_origin'] =
                tableData['country_of_origin'];
          }
        }
      } else {
        userCredentials['user_role'] = 'user';
        userCredentials['marine_worker_id'] = null;
        userCredentials['company_name'] = null;
        userCredentials['country_of_origin'] = null;
      }
    }

    if (userCredentials.isEmpty) {
      if (onWrongCreds != null) {
        onWrongCreds();
      }
      return null;
    }

    return userCredentials;
  }

  Future<List<List<dynamic>>> loadUserInfoByEmail(String email) async {
    final List<List<dynamic>> usernamesById = [];
    var data = await dataProvider.loadQueryResults(
        'SELECT id, user_name FROM user_data ORDER BY id ASC;');

    for (final row in data) {
      usernamesById.add([
        row['user_data']!['id'],
        row['user_data']!['user_name'].toString(),
      ]);
    }

    return usernamesById;
  }

  void changePassword(String newPassword) async {
    await dataProvider
        .loadQueryResults('call changePassword(@i, @p);', subValues: {
      'i': credentials!['id'],
      'p': newPassword,
    });
  }

  Future<void> upgradeToWorker(String company, String country) async {
    await dataProvider.loadQueryResults(
        'INSERT INTO marine_worker(company_name, country_of_origin)'
        'VALUES (@comp, @count);',
        subValues: {
          'comp': company,
          'count': country,
        });

    var data = await dataProvider.loadQueryResults(
        'SELECT id FROM marine_worker WHERE company_name=@e AND country_of_origin=@p;',
        subValues: {
          'e': company,
          'p': country,
        });

    dynamic id;
    for (final row in data) {
      var tableData = row['marine_worker']!;
      id = tableData['id'];
    }

    credentials!['marine_worker_id'] = id;

    await dataProvider.loadQueryResults(
        'INSERT INTO app_user(user_data_id, marine_worker_id, user_role)'
        "VALUES (@id, @mid, 'worker');",
        subValues: {
          'id': credentials!['id'],
          'mid': id,
        });
  }

  void removeAccount() {
    var id = credentials!['id'];
    var mid = credentials!['marine_worker_id'];

    dataProvider
        .loadQueryResults('DELETE FROM user_data WHERE id=@i', subValues: {
      'i': id,
    });

    dataProvider
        .loadQueryResults('DELETE FROM marine_worker WHERE id=@i', subValues: {
      'i': mid,
    });
  }

  Future<void> registerUser(
      String name, String surname, String email, String password) async {
    await dataProvider.loadQueryResults(
        'INSERT INTO user_data(user_name, user_surname, user_email, user_password)'
        'VALUES (@n, @s, @e, @p);',
        subValues: {
          'n': name,
          's': surname,
          'e': email,
          'p': password,
        });
  }
}
