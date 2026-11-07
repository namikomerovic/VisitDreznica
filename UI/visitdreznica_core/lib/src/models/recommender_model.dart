class RecommenderModelInfo {
  RecommenderModelInfo({
    required this.trainedAt,
    required this.isModelTrained,
    required this.interactionCount,
    required this.positiveCount,
    required this.userCount,
    required this.itemCount,
    required this.topK,
    required this.hitRate,
    required this.popularityHitRate,
    required this.randomHitRate,
    required this.evaluatedCount,
    required this.selectedRank,
    required this.selectedLambda,
    required this.selectedAlpha,
    required this.evaluationMethod,
    required this.note,
  });

  final DateTime? trainedAt;
  final bool isModelTrained;
  final int interactionCount;
  final int positiveCount;
  final int userCount;
  final int itemCount;
  final int? topK;
  final double? hitRate;
  final double? popularityHitRate;
  final double? randomHitRate;
  final int evaluatedCount;
  final int? selectedRank;
  final double? selectedLambda;
  final double? selectedAlpha;
  final String? evaluationMethod;
  final String? note;

  static double? _double(dynamic value) => value == null ? null : (value as num).toDouble();

  factory RecommenderModelInfo.fromJson(Map<String, dynamic> json) => RecommenderModelInfo(
        trainedAt: json['trainedAt'] == null ? null : DateTime.parse(json['trainedAt'] as String),
        isModelTrained: json['isModelTrained'] as bool,
        interactionCount: json['interactionCount'] as int,
        positiveCount: json['positiveCount'] as int,
        userCount: json['userCount'] as int,
        itemCount: json['itemCount'] as int,
        topK: json['topK'] as int?,
        hitRate: _double(json['hitRate']),
        popularityHitRate: _double(json['popularityHitRate']),
        randomHitRate: _double(json['randomHitRate']),
        evaluatedCount: json['evaluatedCount'] as int,
        selectedRank: json['selectedRank'] as int?,
        selectedLambda: _double(json['selectedLambda']),
        selectedAlpha: _double(json['selectedAlpha']),
        evaluationMethod: json['evaluationMethod'] as String?,
        note: json['note'] as String?,
      );
}