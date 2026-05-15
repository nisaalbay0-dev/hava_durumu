import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_model.dart';
import 'weather_cubit.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => WeatherCubit(),
        child: WeatherApp(),
      ),
    ));

class WeatherApp extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hava Durumu", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white10,
                  hintText: "İl veya ilçe arayın...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                ),
                onSubmitted: (val) => context.read<WeatherCubit>().fetchWeather(val),
              ),
              SizedBox(height: 30),
              BlocBuilder<WeatherCubit, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) return Center(child: CircularProgressIndicator());
                  if (state is WeatherLoaded) return _buildDetailedUI(state.data);
                  if (state is WeatherError) return Center(child: Text(state.message, style: TextStyle(color: Colors.redAccent)));
                  return Center(child: Text("Hava durumunu görmek için arama yapın.", style: TextStyle(color: Colors.white38)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedUI(Weather data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.indigo, Colors.blueAccent]),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Text(data.icon, style: TextStyle(fontSize: 70)),
              Text("${data.temp}°", style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
              Text(data.cityName, style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
        SizedBox(height: 30),
        Text("Saatlik Tahmin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.hourlyTemps.length,
            itemBuilder: (context, i) => Container(
              width: 70, margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("${12+i}:00"), Text("${data.hourlyTemps[i]}°", style: TextStyle(fontWeight: FontWeight.bold))],
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Text("7 Günlük Tahmin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) => Card(
            color: Colors.white10,
            margin: EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(Icons.wb_cloudy_outlined),
              title: Text("Gün ${index + 1}"),
              trailing: Text("${20 + index}°", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}