import 'package:flutter/foundation.dart';

import '../models/drama_model.dart';
import 'drama_data_source.dart';

enum DramaDataMode { normal, empty, many }

class AssetDramaDataSource implements DramaDataSource {

  static final ValueNotifier<DramaDataMode> mode =
      ValueNotifier(DramaDataMode.normal);

  @override
  Future<List<DramaModel>> fetchAll() async {
    switch (mode.value) {
      case DramaDataMode.normal:
        return _dramas;
      case DramaDataMode.empty:
        return const [];
      case DramaDataMode.many:
        return List.generate(500, (i) {
          final b = _dramas[i % _dramas.length];
          return DramaModel(
            id: 'many-$i',
            title: '${b.title} #${i + 1}',
            mandarinTitle: b.mandarinTitle,
            releaseYear: b.releaseYear,
            totalEpisodes: b.totalEpisodes,
            cast: b.cast,
            genre: b.genre,
          );
        });
    }
  }

  static const List<DramaModel> _dramas = [

    DramaModel(id: '1', title: 'Eternal Love', mandarinTitle: '三生三世十里桃花', releaseYear: 2017, totalEpisodes: 58, cast: 'Yang Mi, Mark Chao', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '2', title: 'Ashes of Love', mandarinTitle: '香蜜沉沉烬如霜', releaseYear: 2018, totalEpisodes: 63, cast: 'Yang Zi, Deng Lun', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '3', title: 'The Untamed', mandarinTitle: '陈情令', releaseYear: 2019, totalEpisodes: 50, cast: 'Xiao Zhan, Wang Yibo', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '4', title: 'Love Between Fairy and Devil', mandarinTitle: '苍兰诀', releaseYear: 2022, totalEpisodes: 36, cast: 'Dylan Wang, Esther Yu', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '5', title: 'Lost You Forever', mandarinTitle: '长相思', releaseYear: 2023, totalEpisodes: 39, cast: 'Yang Zi, Zhang Wanyi', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '6', title: 'Till the End of the Moon', mandarinTitle: '长月烬明', releaseYear: 2023, totalEpisodes: 40, cast: 'Luo Yunxi, Bai Lu', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '7', title: 'The Journey of Flower', mandarinTitle: '花千骨', releaseYear: 2015, totalEpisodes: 53, cast: 'Zhao Liying, Wallace Huo', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '8', title: 'Immortal Samsara', mandarinTitle: '沉香如屑', releaseYear: 2022, totalEpisodes: 40, cast: 'Yang Zi, Cheng Yi', genre: 'Xianxia / Fantasy'),
    DramaModel(id: '9', title: 'The Legend of Shen Li', mandarinTitle: '与凤行', releaseYear: 2024, totalEpisodes: 39, cast: 'Zhao Liying, Lin Gengxin', genre: 'Xianxia / Fantasy'),

    DramaModel(id: '10', title: 'Nirvana in Fire', mandarinTitle: '琅琊榜', releaseYear: 2015, totalEpisodes: 54, cast: 'Hu Ge, Wang Kai', genre: 'Wuxia / Historical'),
    DramaModel(id: '11', title: 'Word of Honor', mandarinTitle: '山河令', releaseYear: 2021, totalEpisodes: 36, cast: 'Zhang Zhehan, Gong Jun', genre: 'Wuxia / Martial Arts'),
    DramaModel(id: '12', title: 'Sword Snow Stride', mandarinTitle: '雪中悍刀行', releaseYear: 2021, totalEpisodes: 38, cast: 'Zhang Ruoyun, Li Gengxi', genre: 'Wuxia / Martial Arts'),
    DramaModel(id: '13', title: 'The Legend of the Condor Heroes (2017)', mandarinTitle: '射雕英雄传', releaseYear: 2017, totalEpisodes: 52, cast: 'Yang Xuwen, Li Yitong', genre: 'Wuxia / Martial Arts'),

    DramaModel(id: '14', title: 'Empresses in the Palace', mandarinTitle: '甄嬛传', releaseYear: 2011, totalEpisodes: 76, cast: 'Sun Li, Chen Jianbin', genre: 'Historical / Palace'),
    DramaModel(id: '15', title: 'Scarlet Heart', mandarinTitle: '步步惊心', releaseYear: 2011, totalEpisodes: 35, cast: 'Liu Shishi, Nicky Wu', genre: 'Historical / Palace'),
    DramaModel(id: '16', title: 'Story of Yanxi Palace', mandarinTitle: '延禧攻略', releaseYear: 2018, totalEpisodes: 70, cast: 'Wu Jinyan, Qin Lan', genre: 'Historical / Palace'),
    DramaModel(id: '17', title: "Ruyi's Royal Love in the Palace", mandarinTitle: '如懿传', releaseYear: 2018, totalEpisodes: 87, cast: 'Zhou Xun, Wallace Huo', genre: 'Historical / Palace'),
    DramaModel(id: '18', title: 'The Rise of Phoenixes', mandarinTitle: '天盛长歌', releaseYear: 2018, totalEpisodes: 70, cast: 'Chen Kun, Ni Ni', genre: 'Historical / Palace'),
  ];
}