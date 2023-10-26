import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/utils.dart';
import 'package:neon_news/neon_news.dart';
import 'package:nextcloud/nextcloud.dart';

part 'routes.g.dart';

@TypedGoRoute<NewsClientRoute>(
  path: '$clientsBaseRoutePrefix${AppIDs.news}',
  name: AppIDs.news,
)
@immutable
class NewsClientRoute extends NeonBaseClientRoute {
  const NewsClientRoute();

  @override
  Widget build(final BuildContext context, final GoRouterState state) => const NewsMainPage();
}
