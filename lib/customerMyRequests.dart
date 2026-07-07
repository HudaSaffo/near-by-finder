import 'package:flutter/material.dart';
import 'package:flutter_nearfix/customernavbar.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final Color primaryMaroon = Color(0xFF5D1219);
final Color backgroundCream = Color(0xFFF9F5EB);
final Color accentSage = Color(0xFF9FB2AC);
final Color textMaroon = Color(0xFF1A0101);

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {



  final supa = Supabase.instance.client;

  List appointments=[];
  List TodayAppoinments=[];


  List<String>monthsList=[
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  bool isLoading =true;

  void initState(){
    super.initState();
    loadData();


  }

  void loadData() async{
    final response=await supa.from("appointments")
        .select(
      '''
      *,
      service(service_name),
      provider_schedule(available_at)
      '''
    )
        .eq("customer_id", supa.auth.currentUser!.id);

    DateTime now=DateTime.now();
    TodayAppoinments.clear();
    for(var appointment in response){
      DateTime allDates =DateTime.parse(appointment['provider_schedule']['available_at']);
      if(allDates.year ==now.year && allDates.month ==now.month && allDates.day ==now.day )
        TodayAppoinments.add(appointment);


    }

    setState(() {
      appointments=response;
      isLoading =false;

      print(response);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return Scaffold(
        backgroundColor: backgroundCream,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: backgroundCream,

      appBar: AppBar(
        actions: [
          SvgPicture.asset('assets/images/logo.svg', width: 35),
          SizedBox(width: 20),
        ],
        backgroundColor: backgroundCream,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          },
          icon: Icon(Icons.notifications_none, size: 30, color: textMaroon),
        ),
        title: Text(
          'My Requests',
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 20),


              TodayAppoinments.isEmpty?Center(child: Text("No appointments scheduled for today.")):
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: TodayAppoinments.length,
                  


                  itemBuilder: (context,index){
                    DateTime date =DateTime.parse(TodayAppoinments[index]['provider_schedule']['available_at']).toLocal();
                    return


                      GestureDetector(onTap: ()async{
                        _showPopupfordelete(TodayAppoinments[index]['id'],appointments[index]["schedule_id"]);
                        loadData();
                        setState(() {

                        });
                      },child:

                      Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                      ),

                      color: Colors.white,

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(

                            contentPadding: EdgeInsets.all(10),
                            title: Row(
                              children: [
                                Icon(Icons.circle, size: 10, color: primaryMaroon),
                                SizedBox(width: 5),
                                Text(
                                  "Appointment",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "${TodayAppoinments[index]["selected_service_type"]}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text("${TodayAppoinments[index]['service']['service_name']}"),

                                Divider(
                                  thickness: 2,
                                  color: Colors.grey.withOpacity(0.2),
                                ),


                                Text(
                                  "${formatTime(date)}",
                                  style: TextStyle(color: Colors.grey),
                                ),



                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "${date.day} ${monthsList[date.month-1]}",
                                    style: TextStyle(
                                      color: Colors.grey,
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

              }),


              SizedBox(height: 20,),









              Text(
                "All Appointments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),

              SizedBox(height: 20),

              appointments.isEmpty?Center(child: Text("You haven't booked any services yet.")):
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,



                  itemBuilder: (context,index){
                    DateTime date =DateTime.parse(appointments[index]['provider_schedule']['available_at']).toLocal();
                    return
                      GestureDetector(onTap: ()async{

                        _showPopupfordelete(appointments[index]["id"],appointments[index]["schedule_id"]);
                        loadData();
                         setState(() {

                         });


                      },child:
                      Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                      ),

                      color: Colors.white,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(

                          contentPadding: EdgeInsets.all(10),
                          title: Row(
                            children: [
                              Icon(Icons.circle, size: 10, color: primaryMaroon),
                              SizedBox(width: 5),
                              Text(
                                "Appointment",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "${appointments[index]["selected_service_type"]}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text("${appointments[index]['service']['service_name']}"),

                              Divider(
                                thickness: 2,
                                color: Colors.grey.withOpacity(0.2),
                              ),


                                Text(
                                  "${formatTime(date)}",
                                  style: TextStyle(color: Colors.grey),
                                ),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "${date.day} ${monthsList[date.month-1]}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      )
                    );

                  }),

            ],
          ),
        ),
      ),

      bottomNavigationBar: Navbar(currentIndex: 1),
    );
  }
  void _showPopupfordelete(String App_id,String sch_id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: backgroundCream,
            title: Text(
              "Remove Appointment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                Text("Are you sure you have to remove this appointment? once removed, it cannot be recovered.", style: TextStyle(fontWeight: FontWeight.bold)),


                SizedBox(height: 20,),



                /// Button
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                        onPressed: () async {
                          
                          await supa.from('provider_schedule').update({'is_booked':false}).eq('id',sch_id );
                          
                          await supa.from("appointments").delete().eq("id",App_id);
                          Navigator.pop(context);

                          loadData();



                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryMaroon,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(100, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text("Delete", style: TextStyle(fontSize: 16)),
                      ),

                      SizedBox(width: 20,),


                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryMaroon,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(100, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );



        } );
  }



  String formatTime (DateTime date ){
    int hour =date.hour;
    String period = hour >=12? "PM" :"AM";
    hour=hour% 12;
    if(hour ==0)hour=12;
    return "${hour}:${date.minute.toString().padLeft(2,'0')} ${period}";


  }
}
