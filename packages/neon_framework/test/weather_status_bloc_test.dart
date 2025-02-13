import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/testing.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:rxdart/rxdart.dart';

Account mockWeatherStatusAccount() {
  String? lat;
  String? lon;
  String? address = 'Berlin';

  Response locationResponse() => Response(
        json.encode({
          'ocs': {
            'meta': {'status': '', 'statuscode': 0},
            'data': {
              'success': true,
              'mode': 2,
              if (lat != null) 'lat': lat,
              if (lon != null) 'lon': lon,
              if (address != null) 'address': address,
            },
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );

  return mockServer({
    RegExp(r'/ocs/v2\.php/apps/weather_status/api/v1/location'): {
      'get': (match, request) => locationResponse(),
      'put': (match, request) {
        final data = json.decode(request.body) as Map<String, dynamic>;

        lat = data['lat'] as String?;
        lon = data['lon'] as String?;
        address = data['address'] as String;
        return locationResponse();
      },
    },
    RegExp(r'/ocs/v2\.php/apps/weather_status/api/v1/forecast'): {
      'get': (match, request) => Response(
            json.encode({
              'ocs': {
                'meta': {'status': '', 'statuscode': 0},
                'data': [
                  {
                    'time': '',
                    'data': {
                      'instant': {
                        'details': {
                          'air_pressure_at_sea_level': 0,
                          'air_temperature': 0,
                          'cloud_area_fraction': 0,
                          'relative_humidity': 0,
                          'wind_from_direction': 0,
                          'wind_speed': 0,
                        },
                      },
                      'next_12_hours': {
                        'summary': {
                          'symbol_code': '',
                        },
                        'details': {
                          'precipitation_amount': 0,
                        },
                      },
                      'next_1_hours': {
                        'summary': {
                          'symbol_code': '',
                        },
                        'details': {
                          'precipitation_amount': 0,
                        },
                      },
                      'next_6_hours': {
                        'summary': {
                          'symbol_code': '',
                        },
                        'details': {
                          'precipitation_amount': 0,
                        },
                      },
                    },
                  }
                ],
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          ),
    },
  });
}

core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data buildCapabilities({required bool enabled}) =>
    core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data(
      (b) => b
        ..version.update(
          (b) => b
            ..major = 0
            ..minor = 0
            ..micro = 0
            ..string = ''
            ..edition = ''
            ..extendedSupport = false,
        )
        ..capabilities = (
          commentsCapabilities: null,
          coreCapabilities: null,
          corePublicCapabilities: null,
          davCapabilities: null,
          dropAccountCapabilities: null,
          filesCapabilities: null,
          filesSharingCapabilities: null,
          filesTrashbinCapabilities: null,
          filesVersionsCapabilities: null,
          notesCapabilities: null,
          notificationsCapabilities: null,
          passwordPolicyCapabilities: null,
          provisioningApiCapabilities: null,
          sharebymailCapabilities: null,
          spreedCapabilities: null,
          spreedPublicCapabilities: null,
          systemtagsCapabilities: null,
          tablesCapabilities: null,
          themingPublicCapabilities: null,
          userStatusCapabilities: null,
          weatherStatusCapabilities: core.WeatherStatusCapabilities(
            (b) => b
              ..weatherStatus.update(
                (b) => b..enabled = enabled,
              ),
          ),
        ),
    );

void main() {
  late Account account;
  late BehaviorSubject<Result<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>> capabilities;
  late WeatherStatusBloc bloc;

  setUp(() {
    FakeNeonStorage.setup();
  });

  setUp(() {
    account = mockWeatherStatusAccount();
    capabilities = BehaviorSubject<Result<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>>();
    bloc = WeatherStatusBloc(
      capabilities: capabilities,
      account: account,
    );
  });

  tearDown(() async {
    await capabilities.close();
    bloc.dispose();
  });

  test('isSupported', () async {
    expect(
      bloc.isSupported,
      emitsInOrder([
        false,
        true,
        false,
      ]),
    );
    capabilities
      ..add(Result.success(buildCapabilities(enabled: false)))
      ..add(Result.success(buildCapabilities(enabled: true)))
      ..add(Result.success(buildCapabilities(enabled: false)));
  });

  test('refresh', () async {
    capabilities.add(Result.success(buildCapabilities(enabled: true)));
    expect(
      bloc.forecasts.transformResult((e) => e!.isNotEmpty),
      emitsInOrder([
        Result<bool>.loading(),
        Result.success(true),
        Result.success(true).asLoading(),
        Result.success(true),
      ]),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await bloc.refresh();
  });

  test('setLocation', () async {
    expect(
      bloc.location.transformResult((e) => e.address),
      emitsInOrder([
        Result.success('Hamburg'),
        Result.success('Berlin'),
      ]),
    );
    bloc
      ..setLocation('Hamburg')
      ..setLocation('Berlin');
  });

  test('Remove location', () async {
    capabilities.add(Result.success(buildCapabilities(enabled: true)));
    expect(
      bloc.forecasts.transformResult((e) => e != null),
      emitsInOrder([
        Result<bool>.loading(),
        Result.success(true),
        Result.success(null),
        Result.success(null),
      ]),
    );

    await Future<void>.delayed(const Duration(milliseconds: 1));
    bloc.setLocation('');
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await bloc.refresh();
  });
}
