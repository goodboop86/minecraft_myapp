import 'package:minecraft/resources/blocks.dart';

class Structure {
  final List<List<Blocks?>> structure;
  final int maxOccurences;
  final int maxWidth;

  Structure(
      {required this.structure,
      required this.maxOccurences,
      required this.maxWidth});
}
