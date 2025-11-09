import 'package:flutter/material.dart';

class Answer2 extends StatelessWidget {
  const Answer2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDECEC),
      appBar: AppBar(
        title: const Text('Concert Ticket'),
        backgroundColor: const Color(0xff607D8B),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xffD4DEE4), 
            borderRadius: BorderRadius.circular(22), 
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 20, 12, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Flutter Live',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          SizedBox(height: 10),
                          Text('Band: The Widgets'),
                           SizedBox(height: 10), 
                          Text('Date: 8 NOV 2025'),
                           SizedBox(height: 10), 
                          Text('Gate: 7'),
                        ],
                      ),
                    ),
                  ),

                  
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xff4A4A4A),
                        borderRadius: BorderRadius.only(
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              
              Positioned(
                top: 0,
                bottom: 0,
                left: 205, 
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
