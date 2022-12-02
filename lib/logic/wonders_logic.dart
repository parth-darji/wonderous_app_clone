import '../models/wonder_data.dart';
import 'data/chichen_Itza_data.dart';
import 'data/christ_redeemer_data.dart';
import 'data/colosseum_data.dart';
import 'data/great_wall_data.dart';
import 'data/machu_picchu_data.dart';
import 'data/petra_data.dart';
import 'data/pyramids_giza_data.dart';
import 'data/taj_mahal_data.dart';

class WondersLogic {
  static List<WonderData> all = [
    GreatWallData(),
    PetraData(),
    ColosseumData(),
    ChichenItzaData(),
    MachuPicchuData(),
    TajMahalData(),
    ChristRedeemerData(),
    PyramidsGizaData(),
  ];
}
