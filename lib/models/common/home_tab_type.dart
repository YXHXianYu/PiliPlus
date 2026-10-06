import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/history/controller.dart';
import 'package:PiliPlus/pages/history/view.dart';
import 'package:PiliPlus/pages/hot/controller.dart';
import 'package:PiliPlus/pages/hot/view.dart';
import 'package:PiliPlus/pages/later/controller.dart';
import 'package:PiliPlus/pages/later/view.dart';
import 'package:PiliPlus/pages/live/controller.dart';
import 'package:PiliPlus/pages/live/view.dart';
import 'package:PiliPlus/pages/pgc/controller.dart';
import 'package:PiliPlus/pages/pgc/view.dart';
import 'package:PiliPlus/pages/rank/controller.dart';
import 'package:PiliPlus/pages/rank/view.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/rcmd/view.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

enum HomeTabType implements EnumWithLabel {
  live('直播'),
  rcmd('推荐'),
  hot('热门'),
  rank('分区'),
  bangumi('番剧'),
  cinema('影视'),
  // 睡前防刷定制：新增稍后再看/历史记录两个首页 tab
  later('稍后再看'),
  history('历史记录'),
  ;

  @override
  final String label;
  const HomeTabType(this.label);

  ScrollOrRefreshMixin Function() get ctr => switch (this) {
    HomeTabType.live => Get.find<LiveController>,
    HomeTabType.rcmd => Get.find<RcmdController>,
    HomeTabType.hot => Get.find<HotController>,
    HomeTabType.rank => Get.find<RankController>,
    HomeTabType.bangumi ||
    HomeTabType.cinema => () => Get.find<PgcController>(tag: name),
    // 稍后再看/历史记录的主列表 controller 分别以固定 tag 注册
    HomeTabType.later => () =>
        Get.find<LaterController>(tag: LaterViewType.all.type.toString()),
    HomeTabType.history => () => Get.find<HistoryController>(tag: 'all'),
  };

  Widget get page => switch (this) {
    HomeTabType.live => const LivePage(),
    HomeTabType.rcmd => const RcmdPage(),
    HomeTabType.hot => const HotPage(),
    HomeTabType.rank => const RankPage(),
    HomeTabType.bangumi => const PgcPage(tabType: HomeTabType.bangumi),
    HomeTabType.cinema => const PgcPage(tabType: HomeTabType.cinema),
    // 嵌入模式：不显示页面自身的 AppBar，完整功能仍可从"我的"页进入
    HomeTabType.later => const LaterPage(embedded: true),
    HomeTabType.history => const HistoryPage(embedded: true),
  };
}
