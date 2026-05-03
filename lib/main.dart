import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(GymTimerApp());

class GymTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Timer',
      theme: ThemeData.dark(), // ธีมมืดเหมาะกับบรรยากาศในยิม
      home: WorkoutTimer(),
    );
  }
}

class WorkoutTimer extends StatefulWidget {
  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  int _sets = 0;
  int _secondsLeft = 60;
  Timer? _timer;
  final TextEditingController _controller = TextEditingController(text: "60");

  void _startRest() {
    _timer?.cancel(); // ล้างตัวนับเก่าถ้ากดซ้ำ

    setState(() {
      _sets++;
      // ดึงค่าเวลาที่ผู้ใช้ตั้งไว้ ถ้าไม่ใช่ตัวเลขให้ใช้ 60
      _secondsLeft = int.tryParse(_controller.text) ?? 60;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer?.cancel();
          // เมื่อครบเวลาจะหยุดนับนิ่งๆ ที่เลข 0
        }
      });
    });
  }

  void _resetSets() {
    _timer?.cancel();
    setState(() {
      _sets = 0;
      _secondsLeft = int.tryParse(_controller.text) ?? 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Text(
                "สำเร็จไปแล้ว",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              Text(
                "$_sets เซ็ท",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 40),
              Text(
                "เวลาพักที่เหลือ",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              Text(
                "$_secondsLeft",
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ตั้งเวลาพัก (วินาที): ",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 50),

              // ปุ่มเริ่มพักขนาดใหญ่
              SizedBox(
                width: 280,
                height: 70,
                child: ElevatedButton(
                  onPressed: _startRest,
                  child: Text(
                    "จบเซ็ท / เริ่มพัก",
                    style: TextStyle(fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // ปุ่มรีเซ็ตขนาดเท่ากัน
              SizedBox(
                width: 280,
                height: 70,
                child: ElevatedButton(
                  onPressed: _resetSets,
                  child: Text(
                    "รีเซ็ตจำนวนเซ็ท",
                    style: TextStyle(fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
