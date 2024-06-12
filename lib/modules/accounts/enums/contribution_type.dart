enum ContributionType {
  day,
  weekly,
  monthly,
  yearly
}

extension ContributionTypeExtension on ContributionType {
  String toLabel() {
    return switch(this) {
      ContributionType.day => 'Day',
      ContributionType.weekly => 'Weekly',
      ContributionType.monthly => 'Monthly',
      ContributionType.yearly => 'Yearly'
    };
  }
}
