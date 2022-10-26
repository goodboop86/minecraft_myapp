import '../resources/blocks.dart';
import 'constants.dart';

class ChunkGenerationMethods {
  static ChunkGenerationMethods get instance {
    return ChunkGenerationMethods();
  }

  List<List<Blocks?>> generateNullChunk() {
    return List.generate(
      chunkHeight,
      (index) => List.generate(chunkWidth, (index) => null),
    );
  }

  List<List<Blocks?>> generateChunk() {
    List<List<Blocks?>> chunk = generateNullChunk();

    chunk.asMap().forEach((int indexOfRow, List<Blocks?> rowOfBlocks) {
      if (indexOfRow == 5) {
        rowOfBlocks.asMap().forEach((int index, Blocks? block) {
          chunk[5][index] = Blocks.grass;
        });
      }
      if (indexOfRow >= 6) {
        rowOfBlocks.asMap().forEach((int index, Blocks? block) {
          chunk[indexOfRow][index] = Blocks.grass;
        });
      }
    });

    return chunk;
  }
}
