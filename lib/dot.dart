import 'package:hive/hive.dart';
part 'dot.g.dart';

@HiveType(typeId: 0)
class Dot extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? content;
  @HiveField(3)
  double? angle;
  @HiveField(4)
  String? childOf;
  @HiveField(5)
  List<String>? children;

  Dot({required this.id, this.title, this.content, this.angle, this.childOf, this.children});
}
