class HelpModels {
  final String? id;
  final String title;
  final String description;
  final FileModels? fileModels;

  HelpModels({
    required this.fileModels,
    required this.description,
    required this.title,
    this.id
  });

  factory HelpModels.fromJson(Map<String, dynamic> data) {
    return HelpModels(
        fileModels: data.containsKey('file') && data['file'] != null ? FileModels.fromJson(data['file']) : null,
        description: data['description'],
        title: data['title'],
        id: data['id']
    );
  }
}

class FileModels {
  final String filename;
  final String mimetype;
  final String originalname;
  final String path;
  final int size;

  FileModels({
    required this.filename,
    required this.size,
    required this.path,
    required this.mimetype,
    required this.originalname
  });

  factory FileModels.fromJson(Map<String, dynamic> data) {
    return FileModels(
        filename: data['filename'],
        size: data['size'],
        path: data['path'],
        mimetype: data['mimetype'],
        originalname: data['originalname']
    );
  }
}