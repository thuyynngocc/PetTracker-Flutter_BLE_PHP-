import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class didaochinh extends StatelessWidget {
  const didaochinh({Key ?key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PetApp(),
    );
  }
}
class PetApp extends StatelessWidget {
  const PetApp({Key ?key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 223, 243, 198),
        title: SizedBox(
              child: Image.asset('assets/dog.png'),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.chevron_left_sharp,size: 40, color: Colors.black,),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
       ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.add,size: 40,  
                color: Colors.black,
              ),
              tooltip: 'Add',
              onPressed: () {
              }),
        ],
      ),
    body: 
    Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.chevron_left, size: 30,),
                Text('Thứ 2',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900)),
                Icon(Icons.chevron_right, size: 30,),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [            
                      Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 306,         
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color.fromARGB(255,182, 227, 161),
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              ),
                                  child: Row(
crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset("assets/dog.png",
                                                  alignment: Alignment.centerLeft,
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover))),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text("Đi dạo",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)                      
                                              ),
                                          Text("7:00",
                                              style:
                                                  TextStyle(fontSize: 11, fontWeight: FontWeight.normal)
                                              ),
                                        ],
                                      ),
                                      const SizedBox(width: 60),
                                      const Icon(
                                        CupertinoIcons.bell_fill,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 20,)
                          ],
                        )
                      ),
                          SizedBox(
                            height: 80,
                            width: 306,         
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: const Color.fromARGB(255,182, 227, 161),
                                  shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset("assets/dog.png",
                                                alignment: Alignment.centerLeft,
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover))),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text("Đi dạo",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                                            ),
                                        Text("10:00",
                                            style:
                                                TextStyle(fontSize: 11, fontWeight: FontWeight.normal)
                                            ),
                                      ],
                                    ),
                                    const SizedBox(width: 60),
                                    const Icon(
                                      CupertinoIcons.bell,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ],
                                ),
                            ),   
                          ],
                        )
                      ),
                        ],
)
                      
                  
                ],
              )
            ),
          ],
        )
          
        
      ],
    ),
       bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () {
            
          }, icon: const Icon(Icons.abc)),
          IconButton(onPressed: () {
            
          }, icon: const Icon(Icons.access_alarm)),
        ],
       ),
    );
  }
}