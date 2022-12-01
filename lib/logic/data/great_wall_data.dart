import '../../enum/wonder_types.dart';
import '../../models/wonders_data.dart';

class GreatWallData extends WonderData {
  GreatWallData()
      : super(
          // searchData: searchData,
          // searchSuggestions: searchSuggestions,
          type: WonderType.greatWall,
          title: 'the Great Wall',
          subTitle: '',
          regionTitle: '',
          videoId: 'do1Go22Wu8o',
          startYr: -700,
          endYr: 1644,
          artifactStartYr: -700,
          artifactEndYr: 1650,
          artifactCulture: '',
          artifactGeolocation: '',
          lat: 40.43199751120627,
          lng: 116.57040708482984,
          unsplashCollectionId: 'Kg_h04xvZEo',
          pullQuote1Top: '',
          pullQuote1Bottom: '',
          pullQuote1Author:
              '', //No key because it doesn't generate for empty values
          pullQuote2: '',
          pullQuote2Author: '',
          callout1: '',
          callout2: '',
          videoCaption: '',
          mapCaption: '',
          historyInfo1: '',
          historyInfo2: '',
          constructionInfo1: '',
          constructionInfo2: '',
          locationInfo1: '',
          locationInfo2: '',
          highlightArtifacts: const [
            '79091',
            '781812',
            '40213',
            '40765',
            '57612',
            '666573',
          ],
          hiddenArtifacts: const [
            '39918',
            '39666',
            '39735',
          ],
          events: {
            -700: '',
            -214: '',
            -121: '',
            556: '',
            618: '',
            1487: '',
          },
        );
}
