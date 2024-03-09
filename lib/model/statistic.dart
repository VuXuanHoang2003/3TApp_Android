class Statistic {
  int numberOfPosts = 0;
  int numberOfSuccessfulTrade = 0;

  double metalRevenue = 0;
  double paperRevenue = 0;
  double plasticRevenue = 0;
  double glassRevenue = 0;
  double otherRevenue = 0;

  double sumOfRevenues = 0;

  Statistic(
      {required this.numberOfPosts,
      required this.numberOfSuccessfulTrade,
      required this.metalRevenue,
      required this.paperRevenue,
      required this.plasticRevenue,
      required this.glassRevenue,
      required this.otherRevenue});

  valuateRevenues() {
    sumOfRevenues = paperRevenue +
        otherRevenue +
        metalRevenue +
        plasticRevenue +
        glassRevenue;

    return sumOfRevenues;
  }

  Statistic.fromJson(Map<String, dynamic> json) {
    numberOfPosts = json['numberOfPosts'];
    numberOfSuccessfulTrade = json['numberOfSuccessfulTrade'];
    metalRevenue = json['metalRevenue'];
    paperRevenue = json['paperRevenue'];
    plasticRevenue = json['plasticRevenue'];
    glassRevenue = json['glassRevenue'];
    otherRevenue = json['otherRevenue'];
    sumOfRevenues = json['sumOfRevenues'];
  }
}
