import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const GymTimerApp());

class GymTimerApp extends StatelessWidget {
  const GymTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Timer',
      theme: ThemeData.dark(), // ธีมมืดเหมาะกับบรรยากาศในยิม
      home: const WorkoutTimer(),
    );
  }
}

class WorkoutTimer extends StatefulWidget {
  const WorkoutTimer({super.key});

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

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                      height: 30), // 1. เพิ่มระยะห่างด้านบนให้มีช่องไฟ
                  const Text(
                    "สำเร็จไปแล้ว",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    "$_sets เซ็ท",
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5), // 2. ลดช่องไฟก่อนคำว่าเวลาพัก
                  const Text(
                    "เวลาพักที่เหลือ",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  // 3. ปรับตัวเลขให้นิ่งขึ้นและช่องไฟน้อยลง
                  Transform.translate(
                    offset: const Offset(
                      0,
                      0,
                    ), // ขยับตัวเลขขึ้นไปหาข้อความด้านบนอีกนิด
                    child: Text(
                      "$_secondsLeft",
                      style: const TextStyle(
                        fontSize: 100, // ปรับขนาดกลับมาเป็น 100 ให้ดูชัดๆ
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                        height: 1.1, // บีบระยะห่างระหว่างบรรทัดของตัวเลข
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ตั้งเวลาพัก: ",
                          style: TextStyle(fontSize: 16)),

                      // ปุ่มลบ (-)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          int current = int.tryParse(_controller.text) ?? 60;
                          if (current > 5) {
                            // ป้องกันไม่ให้เวลาติดลบ
                            setState(() {
                              _controller.text = (current - 5).toString();
                            });
                          }
                        },
                      ),

                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                        ),
                      ),

                      // ปุ่มบวก (+)
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () {
                          int current = int.tryParse(_controller.text) ?? 60;
                          setState(() {
                            _controller.text = (current + 5).toString();
                          });
                        },
                      ),

                      const Text(" วิ", style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  const SizedBox(height: 25), // ระยะห่างก่อนถึงปุ่ม

                  SizedBox(
                    width: screenWidth * 0.80, // กว้างขึ้นอีกนิดเพื่อให้กดง่าย
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _startRest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "จบเซ็ท / เริ่มพัก",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: screenWidth * 0.80,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _resetSets,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "รีเซ็ตจำนวนเซ็ท",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
