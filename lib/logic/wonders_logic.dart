import '../enum/wonder_types.dart';
import '../models/wonders_data.dart';

class WondersLogic {
  List<WonderData> all = [];

  final int timelineStartYear = -3000;
  final int timelineEndYear = 2200;

  WonderData getData(WonderType value) {
    WonderData? result = all.firstWhere((w) => w.type == value);
    // ignore: unnecessary_null_comparison
    if (result == null) throw ('Could not find data for wonder type $value');
    return result;
  }

  // void init() {
  //   all = [
  //     GreatWallData(),
  //     PetraData(),
  //     ColosseumData(),
  //     ChichenItzaData(),
  //     MachuPicchuData(),
  //     TajMahalData(),
  //     ChristRedeemerData(),
  //     PyramidsGizaData(),
  //   ];
  // }
}
