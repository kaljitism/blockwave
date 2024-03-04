import 'package:blockwave/resources/blocks.dart';

class Structure {
  final List<List<Blocks?>> structure;
  final int maxWidth;
  final int maxHeight;
  final int maxOccurrences;

  Structure({
    required this.structure,
    required this.maxWidth,
    required this.maxHeight,
    required this.maxOccurrences,
  });
}
