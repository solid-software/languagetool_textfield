/// Checks if the results are incomplete.
class Warnings {
  ///
  bool incompleteResults;

  ///
  Warnings({
    required this.incompleteResults,
  });

  ///
  factory Warnings.fromJson(Map<String, dynamic> json) => Warnings(
        incompleteResults: json['incompleteResults'] as bool,
      );

  ///
  Map<String, dynamic> toJson() => {
        'incompleteResults': incompleteResults,
      };
}
