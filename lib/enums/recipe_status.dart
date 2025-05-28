enum RecipeStatus { pending, approved, rejected }

extension RecipeStatusExt on RecipeStatus {
  String get label => ['Đang chờ', 'Đã duyệt', 'Từ chối'][index];

  static RecipeStatus fromStr(String status) => RecipeStatus.values.firstWhere(
    (e) => e.name == status,
    orElse: () => RecipeStatus.pending,
  );
}
