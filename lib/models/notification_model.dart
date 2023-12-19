class NotificationModels {
  final String id;
  final String conversationSid;
  final String countryCode;
  final String mobileNo;
  final String assignedTo;
  final String name;

  NotificationModels({required this.name, required this.id, required this.mobileNo, required this.assignedTo,
  required this.conversationSid, required this.countryCode});

  factory NotificationModels.fromJson(Map<String, dynamic> data) {
    return NotificationModels(
      id: data['id'],
      mobileNo: data['mobileNo'],
      assignedTo: data['assignedTo'],
      conversationSid: data['conversationSid'],
      countryCode: data['countryCode'],
      name: data['name']
    );
  }
}