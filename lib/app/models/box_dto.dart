enum BoxColorEnum { red, green, blue }

class BoxDto {
  BoxDto({required this.label, required this.boxNumber, required this.color});
  final String label;
  final int boxNumber;
  final BoxColorEnum color;
}
