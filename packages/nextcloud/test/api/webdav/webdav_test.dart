import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/files_sharing.dart' as files_sharing;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/src/utils/date_time.dart';
import 'package:nextcloud/webdav.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';
import 'package:version/version.dart';

class MockCallbackFunction extends Mock {
  void progressCallback(double progress);
}

class _FileMock extends Mock implements File {}

class _FileStatMock extends Mock implements FileStat {}

void main() {
  test('Chunked responses', () async {
    await HttpServer.bind('127.0.0.1', 0).then((server) async {
      server.listen((request) {
        request.listen(
          (_) {},
          onDone: () async {
            if (request.uri.path == '/index.php/csrftoken') {
              final response = request.response
                ..headers.contentType = ContentType('application', 'json', charset: 'utf-8')
                ..write('{"token":"token"}');

              await response.close();

              return;
            }

            final response = request.response
              ..headers.chunkedTransferEncoding = true
              ..write('1')
              ..write('2')
              ..write('3');

            await response.close();

            await server.close();
          },
        );
      });

      final client = NextcloudClient(
        Uri(
          scheme: 'http',
          host: server.address.host,
          port: server.port,
        ),
      );

      final progress = <double>[];

      final buffer = BytesBuilder(copy: false);
      final stream = await client.webdav.getStream(
        PathUri.cwd(),
        onProgress: progress.add,
      );
      await stream.forEach(buffer.add);

      expect(buffer.toBytes(), utf8.encode('123'));
      expect(progress, [1]);
    });
  });

  group('Invalid status codes are thrown as DynamiteStatusCodeException', () {
    late WebDavClient client;
    late File file;
    late FileStat fileStat;

    setUpAll(() {
      registerFallbackValue(http.Request('get', Uri()) as http.BaseRequest);

      final mockClient = MockClient((request) async {
        return http.Response('', 400);
      });

      client = WebDavClient(
        Uri(),
        httpClient: mockClient,
      );

      file = _FileMock();
      when(() => file.openWrite()).thenReturn(IOSink(StreamController()));
      when(() => file.openRead()).thenAnswer((_) => const Stream.empty());
      fileStat = _FileStatMock();
      when(() => fileStat.size).thenReturn(0);
    });

    for (final entry in <String, Future<void> Function(WebDavClient client)>{
      'options': (client) async => client.options(),
      'mkcol': (client) async => client.mkcol(PathUri.cwd()),
      'delete': (client) async => client.delete(PathUri.cwd()),
      'put': (client) async => client.put(Uint8List(0), PathUri.cwd()),
      'putStream': (client) async => client.putStream(Stream.value(Uint8List(0)), PathUri.cwd(), contentLength: 0),
      'putFile': (client) async => client.putFile(file, fileStat, PathUri.cwd()),
      'get': (client) async => client.get(PathUri.cwd()),
      'getStream': (client) async => client.getStream(PathUri.cwd()),
      'getFile': (client) async => client.getFile(PathUri.cwd(), file),
      'propfind': (client) async => client.propfind(PathUri.cwd()),
      'report': (client) async => client.report(PathUri.cwd(), const WebDavOcFilterRules()),
      'proppatch': (client) async => client.proppatch(PathUri.cwd()),
      'move': (client) async => client.move(PathUri.cwd(), PathUri.cwd()),
      'copy': (client) async => client.copy(PathUri.cwd(), PathUri.cwd()),
    }.entries) {
      test(entry.key, () async {
        await expectLater(
          () async => entry.value(client),
          throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 400)),
        );
      });
    }
  });

  presets('server', 'webdav', (tester) {
    setUpAll(() async {
      await tester.client.webdav.mkcol(PathUri.parse('test'));
      resetFixture();
    });
    tearDownAll(() async {
      closeFixture();
      await tester.client.webdav.delete(PathUri.parse('test'));
    });

    test('List directory', () async {
      final responses = (await tester.client.webdav.propfind(
        PathUri.parse('test'),
        prop: const WebDavPropWithoutValues.fromBools(
          ncHasPreview: true,
          davGetcontenttype: true,
          davGetlastmodified: true,
          ocSize: true,
        ),
      ))
          .responses;
      expect(responses, isNotEmpty);
    });

    test('List directory recursively', () async {
      final responses = (await tester.client.webdav.propfind(
        PathUri.parse('test'),
        depth: WebDavDepth.infinity,
      ))
          .responses;
      expect(responses, isNotEmpty);
    });

    test('Get file props', () async {
      final file = File('test/files/test.png');
      await tester.client.webdav.putFile(file, file.statSync(), PathUri.parse('test/test.png'));

      var response = await tester.client.webdav.propfind(
        PathUri.parse('test/test.png'),
        prop: const WebDavPropWithoutValues.fromBools(
          davCreationdate: true,
          davDisplayname: true,
          davGetcontentlanguage: true,
          davGetcontentlength: true,
          davGetcontenttype: true,
          davGetetag: true,
          davGetlastmodified: true,
          davQuotaAvailableBytes: true,
          davQuotaUsedBytes: true,
          davResourcetype: true,
          ncAclCanManage: true,
          ncAclEnabled: true,
          ncAclList: true,
          ncContainedFileCount: true,
          ncContainedFolderCount: true,
          ncCreationTime: true,
          ncDataFingerprint: true,
          ncGroupFolderId: true,
          ncHasPreview: true,
          ncHidden: true,
          ncInheritedAclList: true,
          ncIsEncrypted: true,
          ncIsMountRoot: true,
          ncLock: true,
          ncLockOwner: true,
          ncLockOwnerDisplayname: true,
          ncLockOwnerEditor: true,
          ncLockOwnerType: true,
          ncLockTime: true,
          ncLockTimeout: true,
          ncLockToken: true,
          ncMountType: true,
          ncNote: true,
          ncReminderDueDate: true,
          ncRichWorkspace: true,
          ncRichWorkspaceFile: true,
          ncShareAttributes: true,
          ncSharees: true,
          ncUploadTime: true,
          ncVersionAuthor: true,
          ncVersionLabel: true,
          ncMetadataBlurhash: true,
          ocChecksums: true,
          ocCommentsCount: true,
          ocCommentsHref: true,
          ocCommentsUnread: true,
          ocDownloadURL: true,
          ocFavorite: true,
          ocFileid: true,
          ocId: true,
          ocOwnerDisplayName: true,
          ocOwnerId: true,
          ocPermissions: true,
          ocShareTypes: true,
          ocSize: true,
          ocTags: true,
          ocmSharePermissions: true,
          ocsSharePermissions: true,
        ),
      );

      var props = response.responses.first.propstats.first.prop;
      expect(props.davCreationdate!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.davDisplayname, 'test.png');
      expect(props.davGetcontentlanguage, isNull);
      expect(props.davGetcontentlength, 8650);
      expect(props.davGetcontenttype, 'image/png');
      expect(props.davGetetag, isNotEmpty);
      expect(props.davGetlastmodified!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.davQuotaAvailableBytes, isNull);
      expect(props.davQuotaUsedBytes, isNull);
      expect(props.davResourcetype!.collection, isNull);
      expect(props.ncCreationTime!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.ncAclCanManage, isNull);
      expect(props.ncAclEnabled, isNull);
      expect(props.ncAclList, isNull);
      expect(props.ncContainedFileCount, isNull);
      expect(props.ncContainedFolderCount, isNull);
      expect(props.ncDataFingerprint, isNull);
      expect(props.ncGroupFolderId, isNull);
      expect(props.ncHasPreview, isTrue);
      expect(props.ncHidden, isFalse);
      expect(props.ncInheritedAclList, isNull);
      expect(props.ncIsEncrypted, isNull);
      expect(props.ncIsMountRoot, isFalse);
      expect(props.ncLock, isNull);
      expect(props.ncLockOwner, isNull);
      expect(props.ncLockOwnerDisplayname, isNull);
      expect(props.ncLockOwnerType, isNull);
      expect(props.ncLockTime, isNull);
      expect(props.ncLockTimeout, isNull);
      expect(props.ncLockToken, isNull);
      expect(props.ncMountType, isNull);
      expect(props.ncNote, isNull);
      expect(props.ncReminderDueDate, isNull);
      expect(props.ncRichWorkspace, isNull);
      expect(props.ncRichWorkspaceFile, isNull);
      expect(json.decode(props.ncShareAttributes!), <String>[]);
      expect(props.ncSharees!.sharees, isNull);
      expect(props.ncUploadTime!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.ncVersionAuthor, isNull);
      expect(props.ncVersionLabel, isNull);
      expect(props.ncMetadataBlurhash, isNull);
      expect(props.ocChecksums, isNull);
      expect(props.ocCommentsCount, 0);
      expect(props.ocCommentsHref, isNotEmpty);
      expect(props.ocCommentsUnread, 0);
      expect(props.ocDownloadURL, isNull);
      expect(props.ocFavorite, false);
      expect(props.ocFileid, greaterThan(0));
      expect(props.ocId, isNotEmpty);
      expect(props.ocOwnerDisplayName, 'User One');
      expect(props.ocOwnerId, 'user1');
      expect(props.ocPermissions, 'RGDNVW');
      expect(props.ocShareTypes!.shareTypes, isNull);
      expect(props.ocSize, 8650);
      expect(props.ocTags!.tags, isNull);
      expect(json.decode(props.ocmSharePermissions!), ['share', 'read', 'write']);
      expect(props.ocsSharePermissions, 19);

      response = await tester.client.webdav.propfind(PathUri.parse('test/test.png'));

      props = response.responses.first.propstats.first.prop;
      expect(props.davCreationdate, isNull);
      expect(props.davDisplayname, isNull);
      expect(props.davGetcontentlanguage, isNull);
      expect(props.davGetcontentlength, 8650);
      expect(props.davGetcontenttype, 'image/png');
      expect(props.davGetetag, isNotEmpty);
      expect(props.davGetlastmodified!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.davQuotaAvailableBytes, isNull);
      expect(props.davQuotaUsedBytes, isNull);
      expect(props.davResourcetype!.collection, isNull);
      expect(props.ncCreationTime, isNull);
      expect(props.ncAclCanManage, isNull);
      expect(props.ncAclEnabled, isNull);
      expect(props.ncAclList, isNull);
      expect(props.ncContainedFileCount, isNull);
      expect(props.ncContainedFolderCount, isNull);
      expect(props.ncDataFingerprint, isNull);
      expect(props.ncGroupFolderId, isNull);
      expect(props.ncHasPreview, isNull);
      expect(props.ncHidden, isNull);
      expect(props.ncInheritedAclList, isNull);
      expect(props.ncIsEncrypted, isNull);
      expect(props.ncIsMountRoot, isNull);
      expect(props.ncLock, isNull);
      expect(props.ncLockOwner, isNull);
      expect(props.ncLockOwnerDisplayname, isNull);
      expect(props.ncLockOwnerType, isNull);
      expect(props.ncLockTime, isNull);
      expect(props.ncLockTimeout, isNull);
      expect(props.ncLockToken, isNull);
      expect(props.ncMountType, isNull);
      expect(props.ncNote, isNull);
      expect(props.ncReminderDueDate, isNull);
      expect(props.ncRichWorkspace, isNull);
      expect(props.ncRichWorkspaceFile, isNull);
      expect(props.ncShareAttributes, isNull);
      expect(props.ncSharees, isNull);
      expect(props.ncUploadTime, isNull);
      expect(props.ncVersionAuthor, isNull);
      expect(props.ncVersionLabel, isNull);
      expect(props.ncMetadataBlurhash, isNull);
      expect(props.ocChecksums, isNull);
      expect(props.ocCommentsCount, isNull);
      expect(props.ocCommentsHref, isNull);
      expect(props.ocCommentsUnread, isNull);
      expect(props.ocDownloadURL, isNull);
      expect(props.ocFavorite, isNull);
      expect(props.ocFileid, isNull);
      expect(props.ocId, isNull);
      expect(props.ocOwnerDisplayName, isNull);
      expect(props.ocOwnerId, isNull);
      expect(props.ocPermissions, isNull);
      expect(props.ocShareTypes, isNull);
      expect(props.ocSize, isNull);
      expect(props.ocTags, isNull);
      expect(props.ocmSharePermissions, isNull);
      expect(props.ocsSharePermissions, isNull);

      closeFixture();
      expect(
        response.toXmlElement(namespaces: namespaces),
        containsAllAvailableProps(tester, PathUri.parse('test/test.png')),
      );
    });

    test('Get directory props', () async {
      await tester.client.webdav.mkcol(PathUri.parse('test/dir-props'));
      final file = File('test/files/test.png');
      await tester.client.webdav.putFile(file, file.statSync(), PathUri.parse('test/dir-props/test.png'));

      var response = await tester.client.webdav.propfind(
        PathUri.parse('test/dir-props'),
        prop: const WebDavPropWithoutValues.fromBools(
          davCreationdate: true,
          davDisplayname: true,
          davGetcontentlanguage: true,
          davGetcontentlength: true,
          davGetcontenttype: true,
          davGetetag: true,
          davGetlastmodified: true,
          davQuotaAvailableBytes: true,
          davQuotaUsedBytes: true,
          davResourcetype: true,
          ncAclCanManage: true,
          ncAclEnabled: true,
          ncAclList: true,
          ncContainedFileCount: true,
          ncContainedFolderCount: true,
          ncCreationTime: true,
          ncDataFingerprint: true,
          ncGroupFolderId: true,
          ncHasPreview: true,
          ncHidden: true,
          ncInheritedAclList: true,
          ncIsEncrypted: true,
          ncIsMountRoot: true,
          ncLock: true,
          ncLockOwner: true,
          ncLockOwnerDisplayname: true,
          ncLockOwnerEditor: true,
          ncLockOwnerType: true,
          ncLockTime: true,
          ncLockTimeout: true,
          ncLockToken: true,
          ncMountType: true,
          ncNote: true,
          ncReminderDueDate: true,
          ncRichWorkspace: true,
          ncRichWorkspaceFile: true,
          ncShareAttributes: true,
          ncSharees: true,
          ncUploadTime: true,
          ncVersionAuthor: true,
          ncVersionLabel: true,
          ncMetadataBlurhash: true,
          ocChecksums: true,
          ocCommentsCount: true,
          ocCommentsHref: true,
          ocCommentsUnread: true,
          ocDownloadURL: true,
          ocFavorite: true,
          ocFileid: true,
          ocId: true,
          ocOwnerDisplayName: true,
          ocOwnerId: true,
          ocPermissions: true,
          ocShareTypes: true,
          ocSize: true,
          ocTags: true,
          ocmSharePermissions: true,
          ocsSharePermissions: true,
        ),
        depth: WebDavDepth.zero,
      );

      var props = response.responses.first.propstats.first.prop;
      expect(props.davCreationdate!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.davDisplayname, 'dir-props');
      expect(props.davGetcontentlanguage, isNull);
      expect(props.davGetcontentlength, isNull);
      expect(props.davGetcontenttype, isNull);
      expect(props.davGetetag, isNotEmpty);
      expect(props.davGetlastmodified!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.davQuotaAvailableBytes, -3);
      expect(props.davQuotaUsedBytes, 8650);
      expect(props.davResourcetype!.collection, <dynamic>[]);
      expect(props.ncCreationTime!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.ncAclCanManage, isNull);
      expect(props.ncAclEnabled, isNull);
      expect(props.ncAclList, isNull);
      expect(props.ncContainedFileCount, 1);
      expect(props.ncContainedFolderCount, 0);
      expect(props.ncDataFingerprint, isNull);
      expect(props.ncGroupFolderId, isNull);
      expect(props.ncHasPreview, isFalse);
      expect(props.ncHidden, isFalse);
      expect(props.ncInheritedAclList, isNull);
      expect(props.ncIsEncrypted, tester.version < Version(30, 0, 0) ? isFalse : isNull);
      expect(props.ncIsMountRoot, isFalse);
      expect(props.ncLock, isNull);
      expect(props.ncLockOwner, isNull);
      expect(props.ncLockOwnerDisplayname, isNull);
      expect(props.ncLockOwnerType, isNull);
      expect(props.ncLockTime, isNull);
      expect(props.ncLockTimeout, isNull);
      expect(props.ncLockToken, isNull);
      expect(props.ncMountType, isNull);
      expect(props.ncNote, isNull);
      expect(props.ncReminderDueDate, isNull);
      expect(props.ncRichWorkspace, isNull);
      expect(props.ncRichWorkspaceFile, isNull);
      expect(json.decode(props.ncShareAttributes!), <String>[]);
      expect(props.ncSharees!.sharees, isNull);
      expect(props.ncUploadTime, isNull);
      expect(props.ncVersionAuthor, isNull);
      expect(props.ncVersionLabel, isNull);
      expect(props.ncMetadataBlurhash, isNull);
      expect(props.ocChecksums, isNull);
      expect(props.ocCommentsCount, 0);
      expect(props.ocCommentsHref, isNotEmpty);
      expect(props.ocCommentsUnread, 0);
      expect(props.ocDownloadURL, isNull);
      expect(props.ocFavorite, false);
      expect(props.ocFileid, greaterThan(0));
      expect(props.ocId, isNotEmpty);
      expect(props.ocOwnerDisplayName, 'User One');
      expect(props.ocOwnerId, 'user1');
      expect(props.ocPermissions, 'RGDNVCK');
      expect(props.ocShareTypes!.shareTypes, isNull);
      expect(props.ocSize, 8650);
      expect(props.ocTags!.tags, isNull);
      expect(json.decode(props.ocmSharePermissions!), ['share', 'read', 'write']);
      expect(props.ocsSharePermissions, 31);

      response = await tester.client.webdav.propfind(PathUri.parse('test/dir-props'));

      props = response.responses.first.propstats.first.prop;
      expect(props.davCreationdate, isNull);
      expect(props.davDisplayname, isNull);
      expect(props.davGetcontentlanguage, isNull);
      expect(props.davGetcontentlength, isNull);
      expect(props.davGetcontenttype, isNull);
      expect(props.davGetetag, isNotEmpty);
      expect(props.davGetlastmodified!.isBefore(DateTime.timestamp()), isTrue);
      expect(props.davQuotaAvailableBytes, -3);
      expect(props.davQuotaUsedBytes, 8650);
      expect(props.davResourcetype!.collection, <dynamic>[]);
      expect(props.ncCreationTime, isNull);
      expect(props.ncAclCanManage, isNull);
      expect(props.ncAclEnabled, isNull);
      expect(props.ncAclList, isNull);
      expect(props.ncContainedFileCount, isNull);
      expect(props.ncContainedFolderCount, isNull);
      expect(props.ncDataFingerprint, isNull);
      expect(props.ncGroupFolderId, isNull);
      expect(props.ncHasPreview, isNull);
      expect(props.ncHidden, isNull);
      expect(props.ncInheritedAclList, isNull);
      expect(props.ncIsEncrypted, isNull);
      expect(props.ncIsMountRoot, isNull);
      expect(props.ncLock, isNull);
      expect(props.ncLockOwner, isNull);
      expect(props.ncLockOwnerDisplayname, isNull);
      expect(props.ncLockOwnerType, isNull);
      expect(props.ncLockTime, isNull);
      expect(props.ncLockTimeout, isNull);
      expect(props.ncLockToken, isNull);
      expect(props.ncMountType, isNull);
      expect(props.ncNote, isNull);
      expect(props.ncReminderDueDate, isNull);
      expect(props.ncRichWorkspace, isNull);
      expect(props.ncRichWorkspaceFile, isNull);
      expect(props.ncShareAttributes, isNull);
      expect(props.ncSharees, isNull);
      expect(props.ncUploadTime, isNull);
      expect(props.ncVersionAuthor, isNull);
      expect(props.ncVersionLabel, isNull);
      expect(props.ncMetadataBlurhash, isNull);
      expect(props.ocChecksums, isNull);
      expect(props.ocCommentsCount, isNull);
      expect(props.ocCommentsHref, isNull);
      expect(props.ocCommentsUnread, isNull);
      expect(props.ocDownloadURL, isNull);
      expect(props.ocFavorite, isNull);
      expect(props.ocFileid, isNull);
      expect(props.ocId, isNull);
      expect(props.ocOwnerDisplayName, isNull);
      expect(props.ocOwnerId, isNull);
      expect(props.ocPermissions, isNull);
      expect(props.ocShareTypes, isNull);
      expect(props.ocSize, isNull);
      expect(props.ocTags, isNull);
      expect(props.ocmSharePermissions, isNull);
      expect(props.ocsSharePermissions, isNull);

      closeFixture();
      expect(
        response.toXmlElement(namespaces: namespaces),
        containsAllAvailableProps(tester, PathUri.parse('test/dir-props')),
      );
    });

    test('Create share', () async {
      final file = File('test/files/test.png');
      await tester.client.webdav.putFile(file, file.statSync(), PathUri.parse('test/share.png'));

      await tester.client.filesSharing.shareapi.createShare(
        $body: files_sharing.ShareapiCreateShareRequestApplicationJson(
          (b) => b
            ..path = '/test/share.png'
            ..shareType = core.ShareType.user.index
            ..shareWith = 'user2',
        ),
      );

      final response = await tester.client.webdav.propfind(
        PathUri.parse('test/share.png'),
        prop: const WebDavPropWithoutValues.fromBools(
          ncShareAttributes: true,
          ncSharees: true,
          ocShareTypes: true,
        ),
      );
      final props = response.responses.single.propstats.first.prop;
      expect(json.decode(props.ncShareAttributes!), <String>[]);
      expect(props.ncSharees!.sharees!.single.id, 'user2');
      expect(props.ncSharees!.sharees!.single.displayName, 'User Two');
      expect(props.ncSharees!.sharees!.single.type, core.ShareType.user.index);
      expect(props.ocShareTypes!.shareTypes!.single, core.ShareType.user.index);
    });

    test('Filter files', () async {
      final response = await tester.client.webdav.put(utf8.encode('test'), PathUri.parse('test/filter.txt'));
      final id = response.headers['oc-fileid'];
      await tester.client.webdav.proppatch(
        PathUri.parse('test/filter.txt'),
        set: const WebDavProp(
          ocFavorite: true,
        ),
      );

      final responses = (await tester.client.webdav.report(
        PathUri.parse('test'),
        const WebDavOcFilterRules(
          ocFavorite: true,
        ),
        prop: const WebDavPropWithoutValues.fromBools(
          ocId: true,
          ocFavorite: true,
        ),
      ))
          .responses;
      expect(responses, isNotEmpty);
      final props = responses.singleWhere((response) => response.href!.endsWith('/filter.txt')).propstats.first.prop;
      expect(props.ocId, id);
      expect(props.ocFavorite, true);
    });

    test('Set properties', () async {
      final lastModifiedDate = DateTime.utc(1972, 3);
      final createdDate = DateTime.utc(1971, 2);
      final uploadTime = DateTime.timestamp();

      await tester.client.webdav.put(
        utf8.encode('test'),
        PathUri.parse('test/set-props.txt'),
        lastModified: lastModifiedDate,
        created: createdDate,
      );

      final response = await tester.client.webdav.proppatch(
        PathUri.parse('test/set-props.txt'),
        set: const WebDavProp(
          ocFavorite: true,
        ),
      );
      expect(
        response.responses.where((r) => r.propstats.where((ps) => !ps.status.contains('200 OK')).isNotEmpty),
        isEmpty,
      );

      final props = (await tester.client.webdav.propfind(
        PathUri.parse('test/set-props.txt'),
        prop: const WebDavPropWithoutValues.fromBools(
          ocFavorite: true,
          davGetlastmodified: true,
          ncCreationTime: true,
          ncUploadTime: true,
        ),
      ))
          .responses
          .single
          .propstats
          .first
          .prop;
      expect(props.ocFavorite, true);
      expect(props.davGetlastmodified, lastModifiedDate);
      expect(props.ncCreationTime, createdDate);
      expect(props.ncUploadTime!.secondsSinceEpoch, closeTo(uploadTime.secondsSinceEpoch, 10));
    });

    test('Remove properties', () async {
      await tester.client.webdav.put(utf8.encode('test'), PathUri.parse('test/remove-props.txt'));

      var response = await tester.client.webdav.proppatch(
        PathUri.parse('test/remove-props.txt'),
        set: const WebDavProp(
          ocFavorite: true,
        ),
      );
      expect(
        response.responses.where((r) => r.propstats.where((ps) => !ps.status.contains('200 OK')).isNotEmpty),
        isEmpty,
      );

      var props = (await tester.client.webdav.propfind(
        PathUri.parse('test/remove-props.txt'),
        prop: const WebDavPropWithoutValues.fromBools(
          ocFavorite: true,
          ncCreationTime: true,
          ncUploadTime: true,
        ),
      ))
          .responses
          .single
          .propstats
          .first
          .prop;
      expect(props.ocFavorite, true);

      response = await tester.client.webdav.proppatch(
        PathUri.parse('test/remove-props.txt'),
        remove: const WebDavPropWithoutValues.fromBools(
          ocFavorite: true,
        ),
      );
      expect(
        response.responses.where((r) => r.propstats.where((ps) => !ps.status.contains('200 OK')).isNotEmpty),
        isNotEmpty,
      );

      props = (await tester.client.webdav.propfind(
        PathUri.parse('test/remove-props.txt'),
        prop: const WebDavPropWithoutValues.fromBools(
          ocFavorite: true,
        ),
      ))
          .responses
          .single
          .propstats
          .first
          .prop;
      expect(props.ocFavorite, false);
    });

    test('Set and get tags', () async {
      await tester.client.webdav.put(
        utf8.encode('test'),
        PathUri.parse('test/tags.txt'),
      );

      var response = await tester.client.webdav.proppatch(
        PathUri.parse('test/tags.txt'),
        set: const WebDavProp(
          ocTags: WebDavOcTags(tags: ['example']),
        ),
      );
      expect(
        response.responses.where((r) => r.propstats.where((ps) => !ps.status.contains('200 OK')).isNotEmpty),
        isEmpty,
      );

      response = await tester.client.webdav.propfind(
        PathUri.parse('test/tags.txt'),
        prop: const WebDavPropWithoutValues.fromBools(
          ocTags: true,
        ),
      );
      final props = response.responses.single.propstats.first.prop;
      expect(props.ocTags!.tags!.single, 'example');
    });

    test('Upload file with checksum', () async {
      final file = File('test/files/test.png');
      await tester.client.webdav.putFile(
        file,
        file.statSync(),
        PathUri.parse('test/checksum.png'),
        checksum: 'md5:abc',
      );

      final response = await tester.client.webdav.propfind(
        PathUri.parse('test/checksum.png'),
        prop: const WebDavPropWithoutValues.fromBools(
          ocChecksums: true,
        ),
      );
      final props = response.responses.single.propstats.first.prop;
      expect(props.ocChecksums!.checksums!.single, 'md5:abc');
    });

    test('Upload and download file', () async {
      final destinationDir = Directory.systemTemp.createTempSync();
      final destination = File('${destinationDir.path}/test.png');
      final source = File('test/files/test.png');
      final progressValues = <double>[];

      await tester.client.webdav.putFile(
        source,
        source.statSync(),
        PathUri.parse('test/upload_file.png'),
        onProgress: progressValues.add,
      );
      await tester.client.webdav.getFile(
        PathUri.parse('test/upload_file.png'),
        destination,
        onProgress: progressValues.add,
      );
      expect(progressValues, containsAll([1.0, 1.0]));
      expect(destination.readAsBytesSync(), source.readAsBytesSync());

      destinationDir.deleteSync(recursive: true);
    });

    test('Upload and download stream', () async {
      final destinationDir = Directory.systemTemp.createTempSync();
      final destination = File('${destinationDir.path}/test.png');
      final source = File('test/files/test.png');
      final progressValues = <double>[];

      await tester.client.webdav.putStream(
        source.openRead(),
        PathUri.parse('test/upload_stream.png'),
        contentLength: source.lengthSync(),
        onProgress: progressValues.add,
      );
      final stream = await tester.client.webdav.getStream(
        PathUri.parse('test/upload_stream.png'),
        onProgress: progressValues.add,
      );
      await stream.pipe(destination.openWrite());
      expect(progressValues, containsAll([1.0, 1.0]));
      expect(destination.readAsBytesSync(), source.readAsBytesSync());

      destinationDir.deleteSync(recursive: true);
    });

    group('Upload overwrite', () {
      test('Data', () async {
        final data1 = Uint8List.fromList(utf8.encode('123'));
        await tester.client.webdav.put(
          data1,
          PathUri.parse('test/upload_overwrite.png'),
        );
        var response = await tester.client.webdav.get(PathUri.parse('test/upload_overwrite.png'));
        expect(response, data1);

        final data2 = Uint8List.fromList(utf8.encode('456'));
        await tester.client.webdav.put(
          data2,
          PathUri.parse('test/upload_overwrite.png'),
        );
        response = await tester.client.webdav.get(PathUri.parse('test/upload_overwrite.png'));
        expect(response, data2);
      });

      test('Stream', () async {
        final data1 = Uint8List.fromList(utf8.encode('123'));
        await tester.client.webdav.putStream(
          Stream.value(data1),
          PathUri.parse('test/upload_overwrite.png'),
          contentLength: data1.length,
        );
        var response = await tester.client.webdav.get(PathUri.parse('test/upload_overwrite.png'));
        expect(response, data1);

        final data2 = Uint8List.fromList(utf8.encode('456'));
        await tester.client.webdav.putStream(
          Stream.value(data2),
          PathUri.parse('test/upload_overwrite.png'),
          contentLength: data2.length,
        );
        response = await tester.client.webdav.get(PathUri.parse('test/upload_overwrite.png'));
        expect(response, data2);
      });
    });

    test('getStream error handling', () async {
      await expectLater(
        () => tester.client.webdav.getStream(PathUri.parse('test/404.txt')),
        throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 404)),
      );
    });

    test('Extended mkcol', () async {
      await tester.client.webdav.mkcol(
        PathUri.parse('test/extended-mkcol'),
        set: const WebDavProp(
          davResourcetype: WebDavResourcetype(collection: [null]),
          ocTags: WebDavOcTags(tags: ['extended']),
        ),
      );

      final propfindResponse = await tester.client.webdav.propfind(
        PathUri.parse('test/extended-mkcol'),
        prop: const WebDavPropWithoutValues.fromBools(
          ocTags: true,
        ),
      );
      final props = propfindResponse.responses.single.propstats.first.prop;
      expect(props.ocTags!.tags!.single, 'extended');
    });

    group('litmus', () {
      group('basic', () {
        test('options', () async {
          final options = await tester.client.webdav.options();
          expect(options.capabilities, contains('1'));
          expect(options.capabilities, contains('3'));
          // Nextcloud only contains a fake plugin for Class 2 support: https://github.com/nextcloud/server/blob/master/apps/dav/lib/Connector/Sabre/FakeLockerPlugin.php
          // It does not actually support locking and is only there for compatibility reasons.
          expect(options.capabilities, isNot(contains('2')));
        });

        for (final (name, path) in [
          ('put_get', 'res'),
          ('put_get_utf8_segment', 'res-%e2%82%ac'),
        ]) {
          test(name, () async {
            final content = utf8.encode('This is a test file');

            await tester.client.webdav.put(content, PathUri.parse('test/$path'));

            final downloadedContent = await tester.client.webdav.get(PathUri.parse('test/$path'));
            expect(downloadedContent, equals(content));
          });
        }

        test('put_no_parent', () async {
          await expectLater(
            () => tester.client.webdav.put(Uint8List(0), PathUri.parse('test/409me/noparent.txt')),
            // https://github.com/nextcloud/server/issues/39625
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 409)),
          );
        });

        test('delete', () async {
          await tester.client.webdav.put(Uint8List(0), PathUri.parse('test/delete.txt'));

          await tester.client.webdav.delete(PathUri.parse('test/delete.txt'));
        });

        test('delete_null', () async {
          await expectLater(
            () => tester.client.webdav.delete(PathUri.parse('test/delete-null.txt')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 404)),
          );
        });

        // delete_fragment: This test is not applicable because the fragment is already removed on the client side

        test('mkcol', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/mkcol'));
        });

        test('mkcol_again', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/mkcol-again'));

          await expectLater(
            () => tester.client.webdav.mkcol(PathUri.parse('test/mkcol-again')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 405)),
          );
        });

        test('delete_coll', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/delete-coll'));

          await tester.client.webdav.delete(PathUri.parse('test/delete-coll'));
        });

        test('mkcol_no_parent', () async {
          await expectLater(
            () => tester.client.webdav.mkcol(PathUri.parse('test/409me/noparent')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 409)),
          );
        });

        // mkcol_with_body: This test is not applicable because we only write valid request bodies
      });

      group('copymove', () {
        test('copy_simple', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/copy-simple-src'));

          await tester.client.webdav.copy(PathUri.parse('test/copy-simple-src'), PathUri.parse('test/copy-simple-dst'));
        });

        test('copy_overwrite', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/copy-overwrite-src'));
          await tester.client.webdav.mkcol(PathUri.parse('test/copy-overwrite-dst'));

          await expectLater(
            () => tester.client.webdav
                .copy(PathUri.parse('test/copy-overwrite-src'), PathUri.parse('test/copy-overwrite-dst')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
          );

          await tester.client.webdav.copy(
            PathUri.parse('test/copy-overwrite-src'),
            PathUri.parse('test/copy-overwrite-dst'),
            overwrite: true,
          );
        });

        test('copy_nodestcoll', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/copy-nodestcoll-src'));

          await expectLater(
            () => tester.client.webdav
                .copy(PathUri.parse('test/copy-nodestcoll-src'), PathUri.parse('test/nonesuch/dst')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 409)),
          );
        });

        test('copy_coll', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/copy-coll-src'));
          await tester.client.webdav.mkcol(PathUri.parse('test/copy-coll-src/sub'));
          for (var i = 0; i < 10; i++) {
            await tester.client.webdav.put(Uint8List(0), PathUri.parse('test/copy-coll-src/$i.txt'));
          }
          await tester.client.webdav.copy(PathUri.parse('test/copy-coll-src'), PathUri.parse('test/copy-coll-dst1'));
          await tester.client.webdav.copy(PathUri.parse('test/copy-coll-src'), PathUri.parse('test/copy-coll-dst2'));

          await expectLater(
            () => tester.client.webdav.copy(PathUri.parse('test/copy-coll-src'), PathUri.parse('test/copy-coll-dst1')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
          );

          await tester.client.webdav.copy(
            PathUri.parse('test/copy-coll-src'),
            PathUri.parse('test/copy-coll-dst2'),
            overwrite: true,
          );

          for (var i = 0; i < 10; i++) {
            await tester.client.webdav.delete(PathUri.parse('test/copy-coll-dst1/$i.txt'));
          }

          await tester.client.webdav.delete(PathUri.parse('test/copy-coll-dst1/sub'));

          await tester.client.webdav.delete(PathUri.parse('test/copy-coll-dst2'));
        });

        // copy_shallow: Does not work on litmus, let's wait for https://github.com/nextcloud/server/issues/39627

        test('move', () async {
          await tester.client.webdav.put(Uint8List(0), PathUri.parse('test/move-src1.txt'));
          await tester.client.webdav.put(Uint8List(0), PathUri.parse('test/move-src2.txt'));
          await tester.client.webdav.mkcol(PathUri.parse('test/move-coll'));

          await tester.client.webdav.move(PathUri.parse('test/move-src1.txt'), PathUri.parse('test/move-dst.txt'));

          await expectLater(
            () => tester.client.webdav.move(PathUri.parse('test/move-src2.txt'), PathUri.parse('test/move-dst.txt')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
          );

          await tester.client.webdav.move(
            PathUri.parse('test/move-src2.txt'),
            PathUri.parse('test/move-dst.txt'),
            overwrite: true,
          );
        });

        test('move_coll', () async {
          await tester.client.webdav.mkcol(PathUri.parse('test/move-coll-src'));
          await tester.client.webdav.mkcol(PathUri.parse('test/move-coll-src/sub'));
          for (var i = 0; i < 10; i++) {
            await tester.client.webdav.put(Uint8List(0), PathUri.parse('test/move-coll-src/$i.txt'));
          }
          await tester.client.webdav.put(Uint8List(0), PathUri.parse('test/move-coll-noncoll'));
          await tester.client.webdav.copy(PathUri.parse('test/move-coll-src'), PathUri.parse('test/move-coll-dst2'));
          await tester.client.webdav.move(PathUri.parse('test/move-coll-src'), PathUri.parse('test/move-coll-dst1'));

          await expectLater(
            () => tester.client.webdav.move(PathUri.parse('test/move-coll-dst1'), PathUri.parse('test/move-coll-dst2')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
          );

          await tester.client.webdav
              .move(PathUri.parse('test/move-coll-dst2'), PathUri.parse('test/move-coll-dst1'), overwrite: true);
          await tester.client.webdav.copy(PathUri.parse('test/move-coll-dst1'), PathUri.parse('test/move-coll-dst2'));

          for (var i = 0; i < 10; i++) {
            await tester.client.webdav.delete(PathUri.parse('test/move-coll-dst1/$i.txt'));
          }

          await tester.client.webdav.delete(PathUri.parse('test/move-coll-dst1/sub'));

          await expectLater(
            () => tester.client.webdav
                .move(PathUri.parse('test/move-coll-dst2'), PathUri.parse('test/move-coll-noncoll')),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 412)),
          );
        });
      });

      group('largefile', () {
        final largefileSize = pow(10, 9).toInt(); // 1GB

        // large_put: Already covered by large_get

        test('large_get', () async {
          await tester.client.webdav.put(Uint8List(largefileSize), PathUri.parse('test/largefile.txt'));

          final downloadedContent = await tester.client.webdav.get(PathUri.parse('test/largefile.txt'));
          expect(downloadedContent, hasLength(largefileSize));
        });
      });

      // props: Most of them are either not applicable or hard/impossible to implement because we don't allow just writing any props
    });

    test('Upload and download empty file', () async {
      final callback = MockCallbackFunction();

      final destinationDir = Directory.systemTemp.createTempSync();
      final destination = File('${destinationDir.path}/empty-file');
      final source = File('${destinationDir.path}/empty-file-source')..createSync();

      await tester.client.webdav.putFile(
        source,
        source.statSync(),
        PathUri.parse('test/empty-file'),
      );
      await tester.client.webdav.getFile(
        PathUri.parse('test/empty-file'),
        destination,
        onProgress: callback.progressCallback,
      );

      verify(() => callback.progressCallback(1)).called(1);
      verifyNever(() => callback.progressCallback(any(that: isNot(1))));

      expect(destination.readAsBytesSync(), isEmpty);
      destinationDir.deleteSync(recursive: true);
    });
  });
}
