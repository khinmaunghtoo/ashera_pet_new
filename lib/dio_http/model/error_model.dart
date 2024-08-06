class ErrorModel {
  int? statusCode;
  int? timestamp;
  String? message;
  String? description;

  ErrorModel({
    required this.message
  });

  ErrorModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    timestamp = json['timestamp'];
    message = json['message'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() => {
    'statusCode':statusCode,
    'timestamp':timestamp,
    'message':message,
    'description':description
  };
}