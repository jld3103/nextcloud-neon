import 'dart:async';
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/testing.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:rxdart/rxdart.dart';

Account mockReferencesAccount() => mockServer({
      RegExp(r'/ocs/v2\.php/references/resolve'): {
        'post': (match, request) {
          final data = json.decode(request.body) as Map<String, dynamic>;
          final references = data['references']! as List;
          if (references.contains('error')) {
            return Response('', 400);
          }

          return Response(
            json.encode(
              {
                'ocs': {
                  'meta': {'status': '', 'statuscode': 0},
                  'data': {
                    'references': {
                      for (final reference in references)
                        reference: {
                          'richObjectType': '',
                          'richObject': <dynamic, dynamic>{},
                          'openGraphObject': {
                            'id': '',
                            'name': '',
                            'link': reference,
                          },
                          'accessible': false,
                        },
                    },
                  },
                },
              },
            ),
            200,
            headers: {'content-type': 'application/json'},
          );
        },
      },
    });

core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data buildCapabilities() =>
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
          coreCapabilities: core.CoreCapabilities(
            (b) => b
              ..core.update(
                (b) => b
                  ..referenceRegex = '[a-z]+'
                  ..referenceApi = true
                  ..pollinterval = 0
                  ..webdavRoot = '',
              ),
          ),
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
          weatherStatusCapabilities: null,
        ),
    );

void main() {
  late Account account;
  late BehaviorSubject<Result<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>> capabilities;
  late ReferencesBloc bloc;

  setUpAll(() {
    FakeNeonStorage.setup();
  });

  setUp(() {
    account = mockReferencesAccount();

    capabilities = BehaviorSubject.seeded(Result.success(buildCapabilities()));

    bloc = ReferencesBloc(
      account: account,
      capabilities: capabilities,
    );
  });

  tearDown(() {
    unawaited(capabilities.close());
    bloc.dispose();
  });

  test('referenceRegex', () {
    expect(
      bloc.referenceRegex.map(
        (result) => result.transform(
          (data) => (
            data!.pattern,
            data.isMultiLine,
            data.isCaseSensitive,
          ),
        ),
      ),
      emitsInOrder([
        Result.success(('[a-z]+', true, false)),
      ]),
    );
  });

  test('loadReferences', () async {
    expect(
      bloc.references.map((e) => e.map((k, v) => MapEntry(k, v.transform((d) => d.openGraphObject.link)))),
      emitsInOrder(<BuiltMap<String, Result<String>>>[
        BuiltMap(),
        BuiltMap({
          'a': Result<String>.loading(),
          'b': Result<String>.loading(),
          'c': Result<String>.loading(),
        }),
        BuiltMap({
          'a': Result.success('a'),
          'b': Result.success('b'),
          'c': Result.success('c'),
        }),
        BuiltMap({
          'a': Result.success('a'),
          'b': Result.success('b'),
          'c': Result.success('c'),
          'd': Result<String>.loading(),
        }),
        BuiltMap({
          'a': Result.success('a'),
          'b': Result.success('b'),
          'c': Result.success('c'),
          'd': Result.success('d'),
        }),
      ]),
    );

    bloc.loadReferences(
      BuiltList([
        'a',
        'b',
        'c',
      ]),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1));
    bloc.loadReferences(
      BuiltList([
        'a',
        'd',
      ]),
    );
  });
}
