import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class themthucan extends StatelessWidget {
  const themthucan({Key ?key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 208, 230, 255),
        title: SizedBox(
          child: Image.asset('assets/an.png',width: 73, height: 70,),
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
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tên thức ăn',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Chọn giờ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(
                height: 250,
              ),
              const Text('Thông báo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.bell,
                            size: 30,
                          )),
                      const Text('Off')
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.bell_fill, size: 30)),
                      const Text('On'),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 175, 213, 255),
                ),
                child: const Text('Thêm',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
