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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        // ใช้ SafeArea เพื่อให้ไม่ไปทับแถบสถานะด้านบน
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // เปลี่ยนจาก center เป็น start
                children: [
                  SizedBox(
                    height: 10,
                  ), // เว้นไว้นิดเดียวแค่ 10 กันตัวหนังสือติดขอบจอเกินไป

                  Text(
                    "สำเร็จไปแล้ว",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    "$_sets เซ็ท",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10), // ลดระยะห่างลง
                  Text(
                    "เวลาพักที่เหลือ",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    "$_secondsLeft",
                    style: TextStyle(
                      fontSize:
                          60, // ลดขนาดตัวเลขเวลาลงจาก 120 เหลือ 80 เพื่อประหยัดที่
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ตั้งเวลาพัก: ", style: TextStyle(fontSize: 16)),
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            isDense: true, // ทำให้ช่องกรอกข้อมูลเล็กลง
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                        ),
                      ),
                      Text(" วิ", style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  SizedBox(height: 20), // ลดช่องว่างก่อนถึงปุ่ม

                  SizedBox(
                    width: screenWidth * 0.8,
                    height: 55, // ลดความสูงปุ่มลงเล็กน้อย
                    child: ElevatedButton(
                      onPressed: _startRest,
                      child: Text(
                        "จบเซ็ท / เริ่มพัก",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  SizedBox(
                    width: screenWidth * 0.8,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _resetSets,
                      child: Text(
                        "รีเซ็ตจำนวนเซ็ท",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
