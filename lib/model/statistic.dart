class Statistic {
  int numberOfPosts = 0;
  int numberOfSuccessfulTrade = 0;

  Statistic(
      {required this.numberOfPosts, required this.numberOfSuccessfulTrade});

  Statistic.fromJson(Map<String, dynamic> json) {
    numberOfPosts = json['numberOfPosts'];
    numberOfSuccessfulTrade = json['numberOfSuccessfulTrade'];
  }
}
