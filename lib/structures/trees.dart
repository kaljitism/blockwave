import 'package:blockwave/resources/blocks.dart';
import 'package:blockwave/resources/structures.dart';

Structure tree = Structure(
  structure: [
    [null, Blocks.birchLeaf, Blocks.birchLeaf, Blocks.birchLeaf, null],
    [
      Blocks.birchLeaf,
      Blocks.birchLeaf,
      Blocks.birchLeaf,
      Blocks.birchLeaf,
      Blocks.birchLeaf
    ],
    [
      Blocks.birchLeaf,
      Blocks.birchLeaf,
      Blocks.birchLeaf,
      Blocks.birchLeaf,
      Blocks.birchLeaf
    ],
    [null, null, Blocks.birchLog, null, null],
    [null, null, Blocks.birchLog, null, null],
  ],
  maxWidth: 5,
  maxHeight: 5,
  maxOccurrences: 1,
);
