class DashboardData {
  final int todayGrossIncome;
  final int todayCashOut;
  final int dailyFundDeduction;
  final int todayNetIncome;

  final int? yesterdayIncome;
  final int? highestIncome;
  final int? lowestIncome;

  final int weekIncome;
  final int monthIncome;
  final int yearIncome;

  final bool hasData;

  const DashboardData({
    required this.todayGrossIncome,
    required this.todayCashOut,
    required this.dailyFundDeduction,
    required this.todayNetIncome,
    this.yesterdayIncome,
    this.highestIncome,
    this.lowestIncome,
    required this.weekIncome,
    required this.monthIncome,
    required this.yearIncome,
    required this.hasData,
  });

  factory DashboardData.initial() {
    return DashboardData(
      todayGrossIncome: 0,
      todayCashOut: 0,
      dailyFundDeduction: 300,
      todayNetIncome: -300,
      weekIncome: 0,
      monthIncome: 0,
      yearIncome: 0,
      hasData: false,
    );
  }
}
