// import 'package:chat_t/themThietBi.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thuyngoc/Beacon/ScanQr.dart';
import 'themThietBi.dart';

class thietbi extends StatelessWidget {
  const thietbi({Key ?key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 239, 226, 255),
          title: SizedBox(
            child: Image.asset('assets/Thietbi.png',width: 87, height: 75,),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.chevron_left_sharp,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.black,
                ),
                tooltip: 'Add',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanQr()));
                }),
          ],
        ),
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/dog_1.png'),
                radius: 100,
              ),
            ),
            Column(
              children: const [
                Text('Mr. Bảnh Tỏn',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                Text(
                  'IMEI: 2011060698',
                  style: TextStyle(fontWeight: FontWeight.w300),
                )
              ],
            ),
            Center(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.flashlight_on)),
                        const Text('Đèn led'),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.ring_volume_outlined)),
                            const Text('Thông báo')
                          ],
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Cảnh báo mức pin', style: TextStyle(fontSize: 20)),
                const SizedBox(
                  height: 20,
                ),
                LinearPercentIndicator(
                  width: 300.0,
                  lineHeight: 35.0,
                  percent: 0.67,
                  backgroundColor: Colors.black12,
                  progressColor: const Color.fromARGB(255, 186, 148, 209),
                  alignment: MainAxisAlignment.center,
                  center: const Text('67%', style: TextStyle(fontSize: 20)),
                  barRadius: const Radius.circular(10.0),
                ),
              ],
            ))
          ],
        ));
  }
}
