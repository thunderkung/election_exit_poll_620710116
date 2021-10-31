import 'package:election_exit_poll_620710116/models/poll_list.dart';
import 'package:election_exit_poll_620710116/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class homapage extends StatefulWidget {
  const homapage({Key? key}) : super(key: key);

  @override
  _homapageState createState() => _homapageState();
}


class _homapageState extends State<homapage> {
 late Future<List<PollList>> _futurePollList;

  @override
  Widget _buildPollCard(BuildContext context) {
    return FutureBuilder<List<PollList>>(
      // ข้อมูลจะมาจาก Future ที่ระบุให้กับ parameter นี้
      future: _futurePollList,

      // ระบุ callback function ซึ่งใน callback นี้เราจะต้อง return widget ที่เหมาะสมออกไป
      // โดยดูจากสถานะของ Future (เช็คสถานะได้จากตัวแปร snapshot)
      builder: (context, snapshot) {
        // กรณีสถานะของ Future ยังไม่สมบูรณ์
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // กรณีสถานะของ Future สมบูรณ์แล้ว แต่เกิด Error
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futurePollList = _loadPolls();
                    });
                  },
                  child: Text('RETRY'),
                ),
              ],
            ),
          );
        }

        // กรณีสถานะของ Future สมบูรณ์ และสำเร็จ
        if (snapshot.hasData) {
          var pollList = snapshot.data;
          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: pollList!.length,
            itemBuilder: (BuildContext context, int index) {
              var elecpoll = pollList[index];

              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(8.0),
                elevation: 5.0,
                shadowColor: Colors.black.withOpacity(0.2),
                child: InkWell(
                  onTap: () => _handleClickCandidate(polls),
                  child: Row(

                    children: <Widget>[
                      Text(elecpoll.toString()), Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${elecpoll.number}', style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${elecpoll.title}${elecpoll.firstname} ${elecpoll.lastname}',
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        }

        return SizedBox.shrink();
      },
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.fill,
            )
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.all(10),
                      child: Image.asset("assets/images/vote_hand.png"
                      ,height: 120.0),
                    ),
                    Text('Exit Poll',style: GoogleFonts.prompt(fontSize: 20.0,color: Colors.white)),
                    Text('เลือกต้ง อบต.',style: GoogleFonts.prompt(fontSize: 20.0,color: Colors.white)),
                    Text('รายชื่อผู้สมัครเลือกตั้ง',style: GoogleFonts.prompt(fontSize: 15.0,color: Colors.white)),
                    Text('นายกองค์กรการบริหารส่วนตำบล',style: GoogleFonts.prompt(fontSize: 15.0,color: Colors.white)),
                    Text('อำเภอเมืองนครนายก จังหวัดนครนายก ',style: GoogleFonts.prompt(fontSize: 15.0,color: Colors.white)),
                     _buildPollCard(context),
                  ],
                ),
              ],
            ),
          ),
        
    );


  }
 Future<List<PollList>> _loadPolls() async {
   List list = await Api().fetch('exit_poll');
   var pollList = list.map((item) => PollList.fromJson(item)).toList();
   return pollList;
 }


 @override
 void initState() {
   super.initState();
   _futurePollList = _loadPolls();
 }
 Future<void> _election(int candidateNumber) async {
   var elector = (await Api().submit('exit_poll', {'candidateNumber': candidateNumber}));
   _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ ${elector.toString()}');
 }

 _handleClickCandidate(PollList polls) {
   _election(polls.number);
 }
 void _showMaterialDialog(String title, String msg) {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: Text(title),
         content: Text(msg,),
         actions: [
           // ปุ่ม OK ใน dialog
           TextButton(
             child: const Text('OK'),
             onPressed: () {
               // ปิด dialog
               Navigator.of(context).pop();
             },
           ),
         ],
       );
     },
   );
 }


}
