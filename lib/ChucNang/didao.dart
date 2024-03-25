import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class didao extends StatelessWidget {
  const didao({Key ?key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 223, 243, 198),
        title: SizedBox(
          child: Image.asset('assets/Didao.png', width: 58, height: 48,),
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
      ),
      body: Center(
        child: ListView(children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.alarm, size: 30),
              Text(
                'Bác sĩ thú y khuyên chó nên tập thể dục 45p mỗi ngày',
                style: TextStyle(fontSize: 12, ),
              )
            ],
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(110, 0, 0, 0),
            leading: Image.asset('assets/dogs-2936442_640.png'),
            title: const Text('Mr. Gảnh Gỗi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                )),
            subtitle: const Text('Mục tiêu: 30 phút'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  const Text(
                    'T2',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 0.80,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
              Column(
                children: [
                  const Text(
                    'T3',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 0.60,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
              Column(
                children: [
                  const Text(
                    'T4',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 0.40,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
              Column(
                children: [
                  const Text(
                    'T5',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 0.40,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
              Column(
                children: [
                  const Text(
                    'T6',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 0.10,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
              Column(
                children: [
                  const Text(
                    'T7',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 0.40,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
              Column(
                children: [
                  const Text(
                    'CN',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 1,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          CircularPercentIndicator(
            radius: 100,
            animation: true,
            animationDuration: 1200,
            lineWidth: 15.0,
            percent: 0.4,
            center: const Text(
              "33m",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45.0),
            ),
            circularStrokeCap: CircularStrokeCap.butt,
            backgroundColor: const Color.fromARGB(255, 223, 243, 198),
            progressColor: const Color.fromARGB(255, 182, 227, 161),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 1,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                  const Text(
                    'Trung bình\n   của bạn',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  ),
                ],
              ),
              const Text(
                'Hôm nay ',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
              ),
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 6.0,
                    percent: 1,
                    backgroundColor: const Color.fromARGB(255, 223, 243, 198),
                    progressColor: const Color.fromARGB(255, 182, 227, 161),
                  ),
                  const Text(
                    ' Trung bình\n người dùng',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  ),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
