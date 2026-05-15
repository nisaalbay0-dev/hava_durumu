import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_model.dart';
import 'dart:math';

abstract class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final Weather data;
  WeatherLoaded(this.data);
}
class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  // LİSTEYİ KÜÇÜK HARFE ÇEVİRDİK (Kontrolü kolaylaştırmak için)
  final List<String> _lokasyonlar = [
    "adana", "ankara", "istanbul", "izmir", "bursa", "antalya", "eskisehir", "kutahya",
    "cukurova", "kozan", "seyhan", "ceyhan", "cankaya", "kecioren", "besiktas", "kadikoy", 
    "alanya", "kas", "odunpazari", "tepebasi", "gediz", "simav", "dumlupinar"
  ];

  void fetchWeather(String query) async {
    // Aramayı hem küçük harfe çeviriyoruz hem de Türkçe karakterleri standartlaştırıyoruz
    final input = query.trim().toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
    
    if (input.isEmpty) return;

    emit(WeatherLoading());
    await Future.delayed(Duration(milliseconds: 500));

    if (_lokasyonlar.contains(input)) {
      emit(WeatherLoaded(Weather(
        cityName: query.toUpperCase(), // Ekranda kullanıcı ne yazdıysa büyük gözüksün
        temp: 20 + Random().nextInt(10),
        desc: "Parçalı Bulutlu",
        icon: "⛅",
        humidity: 45,
        wind: 12.5,
        hourlyTemps: List.generate(12, (index) => 18 + Random().nextInt(8)),
      )));
    } else {
      emit(WeatherError("'$query' bulunamadı. Örn: Gediz, Alanya, Istanbul"));
    }
  }
}