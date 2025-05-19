class BorrowDto {
  BorrowDto({required this.id, required this.friendId, required this.comicId, required this.loanDate, required this.returnDate});
  final String id;
  final String friendId;
  final String comicId;
  final DateTime loanDate;
  final DateTime returnDate;
}
