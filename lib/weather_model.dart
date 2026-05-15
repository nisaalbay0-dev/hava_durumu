class Weather {
  final String cityName;
  final int temp;
  final String desc;
  final String icon;
  final int humidity;
  final double wind;
  final List<int> hourlyTemps;

  Weather({
    required this.cityName, 
    required this.temp, 
    required this.desc,
    required this.icon, 
    required this.humidity, 
    required this.wind,
    required this.hourlyTemps,
  });
}