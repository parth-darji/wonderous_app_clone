import '../utils/enums.dart';

class WonderData {
  const WonderData({
    required this.type,
    required this.title,
  });

  final WonderType type;
  final String title;

  String get titleWithBreaks => title.replaceFirst(' ', '\n');

  @override
  // ignore: override_on_non_overriding_member
  List<Object?> get props => [type, title];
}
