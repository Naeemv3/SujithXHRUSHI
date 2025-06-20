class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> requiredSkills;
  final String company;
  final String sector;
  final String postedBy;
  final String budget;
  final String certification;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredSkills,
    required this.company,
    required this.sector,
    required this.postedBy,
    required this.budget,
    required this.certification,
  });

  factory ProjectModel.fromMap(String id, Map<String, dynamic> map) {
    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
      company: map['company'] ?? '',
      sector: map['sector'] ?? '',
      postedBy: map['postedBy'] ?? '',
      budget: map['budget'] ?? '',
      certification: map['certification'] ?? '',
    );
  }
}
