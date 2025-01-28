import 'dart:io';

import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/files_sharing.dart' as files_sharing;
import 'package:nextcloud/webdav.dart' as webdav;
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:version/version.dart';

void main() {
  presets('server', 'files_sharing', (tester) {
    group('shareapi', () {
      setUp(() async {
        final file = File('test/files/test.png');
        await tester.client.webdav.putFile(file, file.statSync(), webdav.PathUri.parse('create-share.png'));
        resetFixture();
      });

      tearDown(() async {
        closeFixture();
        await tester.client.webdav.delete(webdav.PathUri.parse('create-share.png'));
      });

      test('createShare', () async {
        final response = await tester.client.filesSharing.shareapi.createShare(
          $body: files_sharing.ShareapiCreateShareRequestApplicationJson(
            (b) => b
              ..path = '/create-share.png'
              ..shareType = core.ShareType.user.index
              ..shareWith = 'user2',
          ),
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());
        expect(response.body.ocs.data.canDelete, true);
        expect(response.body.ocs.data.canEdit, true);
        expect(response.body.ocs.data.displaynameFileOwner, 'User One');
        expect(response.body.ocs.data.displaynameOwner, 'User One');
        expect(response.body.ocs.data.fileParent, isPositive);
        expect(response.body.ocs.data.fileSource, isPositive);
        expect(response.body.ocs.data.fileTarget, '/create-share.png');
        expect(response.body.ocs.data.hasPreview, true);
        expect(response.body.ocs.data.hideDownload, files_sharing.Share_HideDownload.$0);
        expect(response.body.ocs.data.id, isNotEmpty);
        expect(response.body.ocs.data.itemMtime, isPositive);
        expect(response.body.ocs.data.itemPermissions, 27);
        expect(response.body.ocs.data.itemSize, 8650);
        expect(response.body.ocs.data.itemSource, isPositive);
        expect(response.body.ocs.data.itemType, files_sharing.Share_ItemType.file);
        expect(response.body.ocs.data.label, '');
        expect(
          response.body.ocs.data.mailSend,
          tester.version == Version(30, 0, 0) ? files_sharing.Share_MailSend.$0 : files_sharing.Share_MailSend.$1,
        );
        expect(response.body.ocs.data.mimetype, 'image/png');
        expect(response.body.ocs.data.note, '');
        expect(response.body.ocs.data.path, '/create-share.png');
        expect(response.body.ocs.data.permissions, 19);
        expect(response.body.ocs.data.shareType, core.ShareType.user.index);
        expect(response.body.ocs.data.shareWith, 'user2');
        expect(response.body.ocs.data.shareWithDisplayname, 'User Two');
        expect(response.body.ocs.data.shareWithDisplaynameUnique, 'user2');
        expect(response.body.ocs.data.stime, isPositive);
        expect(response.body.ocs.data.storage, isPositive);
        expect(response.body.ocs.data.storageId, 'home::user1');
        expect(response.body.ocs.data.uidFileOwner, 'user1');
        expect(response.body.ocs.data.uidOwner, 'user1');
      });

      test('getShares', () async {
        await tester.client.filesSharing.shareapi.createShare(
          $body: files_sharing.ShareapiCreateShareRequestApplicationJson(
            (b) => b
              ..path = '/create-share.png'
              ..shareType = core.ShareType.user.index
              ..shareWith = 'user2',
          ),
        );

        final response = await tester.client.filesSharing.shareapi.getShares(
          path: '/create-share.png',
          reshares: 'true',
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());
        expect(response.body.ocs.data.single.canDelete, true);
        expect(response.body.ocs.data.single.canEdit, true);
        expect(response.body.ocs.data.single.displaynameFileOwner, 'User One');
        expect(response.body.ocs.data.single.displaynameOwner, 'User One');
        expect(response.body.ocs.data.single.fileParent, isPositive);
        expect(response.body.ocs.data.single.fileSource, isPositive);
        expect(response.body.ocs.data.single.fileTarget, '/create-share.png');
        expect(response.body.ocs.data.single.hasPreview, true);
        expect(response.body.ocs.data.single.hideDownload, files_sharing.Share_HideDownload.$0);
        expect(response.body.ocs.data.single.id, isNotEmpty);
        expect(response.body.ocs.data.single.itemMtime, isPositive);
        expect(response.body.ocs.data.single.itemPermissions, 27);
        expect(response.body.ocs.data.single.itemSize, 8650);
        expect(response.body.ocs.data.single.itemSource, isPositive);
        expect(response.body.ocs.data.single.itemType, files_sharing.Share_ItemType.file);
        expect(response.body.ocs.data.single.label, '');
        expect(response.body.ocs.data.single.mailSend, files_sharing.Share_MailSend.$0);
        expect(response.body.ocs.data.single.mimetype, 'image/png');
        expect(response.body.ocs.data.single.note, '');
        expect(response.body.ocs.data.single.path, '/create-share.png');
        expect(response.body.ocs.data.single.permissions, 19);
        expect(response.body.ocs.data.single.shareType, core.ShareType.user.index);
        expect(response.body.ocs.data.single.shareWith, 'user2');
        expect(response.body.ocs.data.single.shareWithDisplayname, 'User Two');
        expect(response.body.ocs.data.single.shareWithDisplaynameUnique, 'user2');
        expect(response.body.ocs.data.single.stime, isPositive);
        expect(response.body.ocs.data.single.storage, isPositive);
        expect(response.body.ocs.data.single.storageId, 'home::user1');
        expect(response.body.ocs.data.single.uidFileOwner, 'user1');
        expect(response.body.ocs.data.single.uidOwner, 'user1');
      });
    });
  });
}
