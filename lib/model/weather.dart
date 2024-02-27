class GroupedWeather {
  int min;
  int max;
  String description;
  String icon;
  String day;

  GroupedWeather(this.min, this.max, this.description, this.icon, this.day);

  String minAndMax() => "Min: $min°C - Max: $max°C";
}
