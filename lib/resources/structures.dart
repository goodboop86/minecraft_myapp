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

Structure treeStructure = Structure(
  structure: [
    [Blocks.birchLeaf, Blocks.birchLeaf, Blocks.birchLeaf],
    [Blocks.birchLeaf, Blocks.birchLeaf, Blocks.birchLeaf],
    [Blocks.birchLeaf, Blocks.birchLeaf, Blocks.birchLeaf],
    [null, Blocks.birchLog, null],
    [null, Blocks.birchLog, null],
  ],
  maxOccurences: 1,
  maxWidth: 3,
);
