class QuickReplyModels {
  final List<String> replies;
  final String title;

  QuickReplyModels({required this.title, required this.replies});

  factory QuickReplyModels.fromJson(Map<String, dynamic> data) {
    return QuickReplyModels(
      title: data['title'],
      replies: (data['replies'] as List<dynamic>).map((e) => e as String).toList()
    );
  }
}