import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String token = '8e32ab2f3105f7ff2a5423241f42825816d4dc3a'; 
const String defaultCity = 'bangkok';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality Index',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        primaryColor: const Color(0xFF0A1931), 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: const AqiExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AqiExample extends StatefulWidget {
  const AqiExample({super.key});

  @override
  State<AqiExample> createState() => _ApiExampleState();
}

class _ApiExampleState extends State<AqiExample> {
  bool loading = true;
  String cityName = '';
  int aqi = 0;
  double tempC = 0;
  double? humidity;
  double? wind;
  double? pressure;
  double? pm25;
  double? pm10;
  String? updateText;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
      error = null;
    });

    final url = 'https://api.waqi.info/feed/$defaultCity/?token=$token';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = json.decode(res.body);
      if (body['status'] != 'ok') {
        throw Exception('API status: ${body['status']}');
      }

      final data = body['data'];
      setState(() {
        aqi = data['aqi'] ?? 0;
        cityName = data['city']?['name'] ?? defaultCity;
        tempC = (data['iaqi']?['t']?['v'] ?? 0).toDouble();
        humidity = (data['iaqi']?['h']?['v'] as num?)?.toDouble();
        wind = (data['iaqi']?['w']?['v'] as num?)?.toDouble();
        pressure = (data['iaqi']?['p']?['v'] as num?)?.toDouble();
        pm25 = (data['iaqi']?['pm25']?['v'] as num?)?.toDouble();
        pm10 = (data['iaqi']?['pm10']?['v'] as num?)?.toDouble();
        final ts = data['time']?['s'] as String?;
        if (ts != null) {
          updateText = prettyTime(ts);
        }
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String prettyTime(String s) {
    final parts = s.split(' ');
    final datePart = parts[0];
    final timePart = parts[1].substring(0, 5);
    final date = DateTime.parse("$datePart $timePart:00");
    const weekdays = ['วันจันทร์','วันอังคาร','วันพุธ','วันพฤหัสบดี','วันศุกร์','วันเสาร์','วันอาทิตย์'];
    final weekday = weekdays[date.weekday - 1];
    return 'อัปเดตล่าสุด: $weekday เวลา $timePart';
  }

  Map<String, dynamic> aqiStyle(int aqi) {
    if (aqi <= 50) return {"color": const Color(0xFF4CAF50), "label": "Good"};
    if (aqi <= 100) return {"color": const Color(0xFFFFEB3B), "label": "Moderate"};
    if (aqi <= 150) return {"color": const Color(0xFFFF9800), "label": "Unhealthy for SG"};
    if (aqi <= 200) return {"color": const Color(0xFFF44336), "label": "Unhealthy"};
    if (aqi <= 300) return {"color": const Color(0xFF9C27B0), "label": "Very Unhealthy"};
    return {"color": const Color(0xFF795548), "label": "Hazardous"};
  }

  Widget _buildLocationHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.blueGrey[600]),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  cityName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (updateText != null)
            Text(updateText!, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAqiCard() {
    final style = aqiStyle(aqi);
    final Color textColor = (style["color"] as Color).computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('US AQI', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
                Text(aqi.toString(), style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: style["color"], borderRadius: BorderRadius.circular(20)),
              child: Text(style["label"], style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Detailed Observations", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildDetailItem(Icons.thermostat, "${tempC.toStringAsFixed(1)}°C", "Temperature"),
                _buildDetailItem(Icons.water_drop_outlined, humidity == null ? "-" : "${humidity!.toStringAsFixed(0)}%", "Humidity"),
                _buildDetailItem(Icons.air, wind == null ? "-" : "${wind!.toStringAsFixed(1)} m/s", "Wind"),
                _buildDetailItem(Icons.cloud_queue_outlined, pm25 == null ? "-" : pm25!.toStringAsFixed(1), "PM2.5"),
                _buildDetailItem(Icons.cloud, pm10 == null ? "-" : pm10!.toStringAsFixed(1), "PM10"),
                _buildDetailItem(Icons.compress, pressure == null ? "-" : "${pressure!.toStringAsFixed(0)}", "Pressure"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueGrey, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Air Quality Monitor"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: loading ? null : fetchData,
        label: const Text('Refresh'),
        icon: const Icon(Icons.refresh),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, color: Colors.red, size: 50),
                        const SizedBox(height: 16),
                        const Text("Failed to load data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          "Error: $error\nPlease check your internet connection or API token.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: fetchData,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Try Again"),
                        )
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchData,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    children: [
                      _buildLocationHeader(),
                      _buildAqiCard(),
                      _buildDetailsGrid(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }
}