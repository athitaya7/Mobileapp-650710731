import 'package:flutter/material.dart';

class Answer3 extends StatefulWidget {
  const Answer3({super.key});

  @override
  State<Answer3> createState() => _Answer3State();
}

class _Answer3State extends State<Answer3> {
  final _formKey = GlobalKey<FormState>();

  int _basePrice = 200; 
  bool _vacuum = true;
  bool _wax = true;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() {
    int total = _basePrice;
    if (_vacuum) total += 50;
    if (_wax) total += 100;
    setState(() {
      _total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2FF), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                const Text(
                  'คำนวณค่าบริการล้างรถ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

         
                const Text(
                  'ขนาดรถ',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                DropdownButtonFormField<int>(
                  value: _basePrice,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 150,
                      child: Text('รถเล็ก (Small) - 150 บาท'),
                    ),
                    DropdownMenuItem(
                      value: 200,
                      child: Text(
                        'รถเก๋ง (Medium) - 200 บาท',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 250,
                      child: Text('รถ SUV/กระบะ (Large) - 250 บาท'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _basePrice = value!;
                      _calculateTotal();
                    });
                  },
                ),

                const SizedBox(height: 25),

                CheckboxListTile(
                  activeColor: Colors.purple,
                  title: const Text('ดูดฝุ่น (+50 บาท)'),
                  value: _vacuum,
                  onChanged: (value) {
                    setState(() {
                      _vacuum = value!;
                      _calculateTotal();
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                ),

              
                CheckboxListTile(
                  activeColor: const Color.fromARGB(255, 109, 86, 113),
                  title: const Text('เคลือบแว็กซ์ (+100 บาท)'),
                  value: _wax,
                  onChanged: (value) {
                    setState(() {
                      _wax = value!;
                      _calculateTotal();
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                ),

                const Divider(thickness: 1, color: Colors.grey),

                const SizedBox(height: 20),

             
                Center(
                  child: Text(
                    'ราคารวม: $_total บาท',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
