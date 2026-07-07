import 'package:flutter/material.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_nearfix/serviceNavbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_nearfix/categoryServices.dart';


class ServiceDashboard extends StatefulWidget {
  const ServiceDashboard({super.key});

  @override
  State<ServiceDashboard> createState() => _ServiceDashboardState();
}

class _ServiceDashboardState extends State<ServiceDashboard> {
  final Color primaryMaroon = Color(0xFF5D1219);
  final Color backgroundCream = Color(0xFFF9F5EB);
  final Color accentSage = Color(0xFF9FB2AC);
  final Color textMaroon = Color(0xFF1A0101);

  String? day;
  String? month;
  String? year;
  String? time;

  int? hour;
  int? minute;


  List Morning=[];
  List AfterNoon=[];
  List Evening=[];



  DateTime displayedMonth=DateTime.now();
  int selectedDay=-1;
  DateTime? selectedDate;

  Map<String,dynamic>? selectedTime;

  String? service_id;
  int active_job=0;


  List ListOfReviews=[];


  int sumOfRating=0;
  double TotalRating=0;

  var nextAppointment;
  String? DateOfNextappointment;
  DateTime? TimeOfNextappointment;

  bool isLoading =true;


  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  List<String> daysList = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];
  List<String>? DropDownMenuDays;
  List<String> years = List.generate(10, (index) => (2025 + index).toString());
  List<String> times = List.generate(48, (index){
    int ForHours = index ~/2;
    int ForMinutes =(index%2)*30;
    return "${ForHours.toString().padLeft(2,'0')}:${ForMinutes.toString().padLeft(2,'0')}";
  });




  final supa = Supabase.instance.client;
  DateTime? FullTime;


  List schedule=[];



  void initState(){
    super.initState();
    loadData();


  }

  void loadData() async {
    try{
    final response = await supa.from("provider_schedule")
        .select()
        .eq("provider_id", supa.auth.currentUser!.id);

    final service = await supa.from("service")
        .select("id")
        .eq("provider_id", supa.auth.currentUser!.id)
        .maybeSingle();

if(service == null){
  ContinueInfo();
  setState(() {
    isLoading=false;

  });
  return;
}



    service_id = service['id'];

    final appointments =
    await supa.from("appointments")
        .select(
        ''' 
        *,
        customers(full_name),
        service(service_name),
        provider_schedule(available_at)
        
        '''
    )
        .eq("provider_id", supa.auth.currentUser!.id).order(
        "available_at", referencedTable: "provider_schedule");

    final reviews= await supa.from("FeedBack")
        .select().eq("service_id", service_id!);


    appointments.sort((a,b){
      DateTime dateA= DateTime.parse(a["provider_schedule"]["available_at"]);
      DateTime dateB= DateTime.parse(b["provider_schedule"]["available_at"]);

      return dateA.compareTo(dateB);

    });


    setState(() {
      schedule = response;
      active_job = appointments.length;
      ListOfReviews=reviews;
      if(appointments.isNotEmpty) {
        nextAppointment = appointments.first;
        DateOfNextappointment = "${months[DateTime
            .parse(nextAppointment["provider_schedule"]["available_at"])
            .month - 1]}, ${DateTime
            .parse(nextAppointment["provider_schedule"]["available_at"])
            .day} ${DateTime
            .parse(nextAppointment["provider_schedule"]["available_at"])
            .year}";
        TimeOfNextappointment = DateTime.parse(
            nextAppointment["provider_schedule"]["available_at"]);
      }
      isLoading = false;

      if (selectedDate != null)
        filterAppointments(selectedDate!);
    });
  }catch(e){
    isLoading=false;
      print(e);

    }
  }


  @override
  Widget build(BuildContext context) {


    if(ListOfReviews.isEmpty) {
      TotalRating = 0;
    }
    else{
      sumOfRating=0;
      for(int i=0;i<ListOfReviews.length;i++)
        sumOfRating=sumOfRating+ListOfReviews[i]['rating'] as int;
      TotalRating=sumOfRating/ListOfReviews.length;
    }



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
          'Dashboard',
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _appointmentCard(),
                    const SizedBox(height: 14),

                    _statsRow(),
                    const SizedBox(height: 14),

                    Expanded(child: _scheduleSection()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: serviceNavbar(currentIndex: 0),
    );
  }

  // Appointment Card
  Widget _appointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: nextAppointment==null?Text("No appointment available at this time"):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Next Appointment:",
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 6),
           Text(
            "${nextAppointment["customers"]["full_name"]}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textMaroon,
            ),
          ),
          SizedBox(height: 6,),
          Text(
            "${nextAppointment["selected_service_type"]}",

            style: TextStyle(color: Colors.grey.shade500),
          ),
          SizedBox(height: 6,),

          Text(
            "${DateOfNextappointment} at ${formatTime(TimeOfNextappointment!)}",

            style: TextStyle(color: Colors.grey.shade500),
          ),

          const SizedBox(height: 12),

          /// Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/servicerequest');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Go to Appointments"),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Row
  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statCard("Active jobs","$active_job")),
        const SizedBox(width: 10),
        Expanded(child: _statCard("Rated", "${TotalRating}")),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      height: 120,
      decoration: _cardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Schedule Section
  Widget _scheduleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + add button
            Row(
              children: [
                 Text(
                  "Schedule",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textMaroon,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _showPopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryMaroon,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(50, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),


      Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    displayedMonth=DateTime(
                        displayedMonth.year,
                        displayedMonth.month-1,
                        1

                    );
                    selectedDay=-1;
                  });
                },
                icon: Icon(
                  Icons.arrow_circle_left_outlined,
                  color: accentSage,
                ),
              ),
              Text(
                "${months[displayedMonth.month-1]} ${displayedMonth.year}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    displayedMonth=DateTime(
                        displayedMonth.year,
                        displayedMonth.month+1,
                        1

                    );
                    selectedDay=-1;
                  });
                },
                icon: Icon(
                  Icons.arrow_circle_right_outlined,
                  color: accentSage,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: DateTime(
                displayedMonth.year,
                displayedMonth.month+1,
                0,
              ).day,
              itemBuilder: (context, index) {
                DateTime curruntDay =DateTime(
                    displayedMonth.year,
                    displayedMonth.month,
                    index+1
                );
                bool isSelected = selectedDay==index;

                return GestureDetector(
                  onTap: (){

                    filterAppointments(curruntDay);

                    setState(() {

                      selectedDay=index;
                      selectedDate=curruntDay;



                    });},
                  child:
                  Container(
                    width: 70,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? accentSage : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          daysList[curruntDay.weekday-1],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${curruntDay.day}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),

                      ],

                    ),
                  ),
                );
              },
            ),
          ),

            const SizedBox(height: 20),



      Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Morning:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Morning.isEmpty?Center(child: Text("No appointment available at this time")):
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: Morning.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 1,

                ),
                itemBuilder: (context,index){
                  bool isbooked=Morning[index]["is_booked"];



                  DateTime date =DateTime.parse(Morning[index]["available_at"]);

                  return GestureDetector(onTap: (){
                    if(isbooked)
                      return;

                    setState(() {

                      selectedTime=Morning[index];
                      _showPopupfordelete();


                    });
                  },
                      child: _timeBox("${formatTime(date)}",isbooked)




                  );

                }

            )

          ],
      ),

            const SizedBox(height: 20),

          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AfterNoon",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              AfterNoon.isEmpty?Center(child: Text("No appointment available at this time")):
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: AfterNoon.length,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 1,

                  ),
                  itemBuilder: (context,index){
                    bool isbooked=AfterNoon[index]["is_booked"];



                    DateTime date =DateTime.parse(AfterNoon[index]["available_at"]);

                    return GestureDetector(onTap: (){
                      if(isbooked)
                        return;

                      setState(() {

                        selectedTime=AfterNoon[index];
                        _showPopupfordelete();




                      });
                    },
                        child: _timeBox("${formatTime(date)}",isbooked)




                    );

                  }

              )

            ],
          ),
          SizedBox(height: 20,),

          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Evening:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              Evening.isEmpty?Center(child: Text("No appointment available at this time")):
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Evening.length,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 1,

                  ),
                  itemBuilder: (context,index){
                    bool isbooked=Evening[index]["is_booked"];



                    DateTime date =DateTime.parse(Evening[index]["available_at"]);

                    return GestureDetector(onTap: (){
                      if(isbooked)
                        return;

                      setState(() {

                        selectedTime=Evening[index];
                        _showPopupfordelete();



                      });
                    },
                        child: _timeBox("${formatTime(date)}",isbooked)




                    );

                  }

              )

            ],
          ),
          SizedBox(height: 20,),




          ]
    ),


]
    )
    )


    );
  }

  /// Time Box
  Widget _timeBox(String time,bool isbooked) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isbooked?Colors.grey:Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.black.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(

        time,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color:Colors.black,
        ),
      ),
    );
  }

  /// Popup
  void _showPopup() {
    year=null;
    month=null;
    day=null;
    time=null;
    DropDownMenuDays=null;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(

          builder: (context,setDialogState) {
            int daysInMonth=31;
            if(month != null && year !=null){
              daysInMonth=DateTime(
                  int.parse(year!),
              months.indexOf(month!)+2,
              0).day;

               DropDownMenuDays=List.generate(daysInMonth, (index) => (index+1).toString());
            }

            return AlertDialog(

              backgroundColor: backgroundCream,
              title: Text(
                "Add working times",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      /// Day
                      Expanded(
                        child: DropdownButton<String>(
                          hint:Text("Day")  ,
                          value: day,
                          isExpanded: true,
                          items: DropDownMenuDays?.map<DropdownMenuItem<String>>((String d) {
                            return DropdownMenuItem(value: d, child: Text(d));
                          }).toList(),
                          onChanged: (m) {
                            setDialogState(() {
                              day = m!;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// Month
                      Expanded(
                        child: DropdownButton<String>(
                          hint: const Text("Month"),
                          value: month,
                          isExpanded: true,
                          items: months.map<DropdownMenuItem<String>>((String m) {
                            return DropdownMenuItem(value: m, child: Text(m));
                          }).toList(),
                          onChanged: (m) {
                            setDialogState(() {
                              month = m!;
                              day=null;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// Year
                      Expanded(
                        child: DropdownButton<String>(
                          hint: const Text("Year"),
                          value: year,
                          isExpanded: true,
                          items: years.map<DropdownMenuItem<String>>((String y) {
                            return DropdownMenuItem(value: y, child: Text(y));
                          }).toList(),
                          onChanged: (m) {
                            setDialogState(() {
                              year = m!;
                            });
                          },

                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5,),

                  if(month == null || year == null)
                    Text("select month and year first",style: TextStyle(color: Colors.grey,fontSize: 10)),

                  const SizedBox(height: 20),

                  Text("Time", style: TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),

                  /// Time
                  DropdownButton<String>(
                    hint: const Text("Time"),
                    value: time,
                    isExpanded: true,
                    items: times.map<DropdownMenuItem<String>>((String t) {
                      return DropdownMenuItem(value: t, child: Text("${DropDownformatTime(t)}"));
                    }).toList(),
                    onChanged: (m) {
                      setDialogState(() {
                        time = m!;
                        List Hours_Mins=time!.split(":");
                         hour=int.parse(Hours_Mins[0]);
                         minute=int.parse(Hours_Mins[1]);
                      });
                    },

                  ),

                  const SizedBox(height: 26),

                  /// Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if(year == null || month == null || day == null || hour == null || minute == null  ) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("please select time and date before continuing.")));

                          return;
                        }
                        FullTime=DateTime(int.parse(year!),months.indexOf(month!)+1,int.parse(day!),hour!,minute!);

                        final existing = await supa.from('provider_schedule')
                        .select()
                        .eq("provider_id", supa.auth.currentUser!.id)
                        .eq("available_at", FullTime!.toIso8601String());


                        if(existing.isNotEmpty) {

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("This appointment is already exist")));
                          return;

                        }



                          await supa.from('provider_schedule').insert({
                            "provider_id": supa.auth.currentUser!.id,
                            "available_at": FullTime!.toIso8601String(),
                            "service_id": service_id,
                            "is_booked": false
                          });

                          loadData();



                        setState(() {
                        });
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
                      child: const Text("Add", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  /// Card Style
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
      ],
    );
  }
  void filterAppointments(DateTime curruntDay){

    Morning.clear();
    AfterNoon.clear();
    Evening.clear();

    for(var time in schedule){

      DateTime date=DateTime.parse(time["available_at"]);

      if(date.year ==curruntDay.year && date.month == curruntDay.month && date.day == curruntDay.day){
        if(date.hour <12)
          Morning.add(time);
        else if(date.hour <17)
          AfterNoon.add(time);
        else
          Evening.add(time);


      }
    }


  }


  void _showPopupfordelete() {
    DateTime date =DateTime.parse(selectedTime!["available_at"]);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: backgroundCream,
            title: Text(
              "Delete Appointment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                  Text("Are you sure you want to delete this appointment?", style: TextStyle(fontWeight: FontWeight.bold)),

                  Center(child: Text("${months[date.month-1]} ${date.day}, ${date.year} at ${formatTime(date)}.", style: TextStyle(fontWeight: FontWeight.bold))),

                SizedBox(height: 20,),



                /// Button
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                        onPressed: () async {
                          await supa.from("provider_schedule").delete().eq("id", selectedTime!["id"]);
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

  String DropDownformatTime (String time ){
    List parts=time.split(":");
    int hour =int.parse(parts[0]);
    String minute=parts[1];
    String period = hour >=12? "PM" :"AM";
    hour=hour% 12;
    if(hour ==0)hour=12;
    return "${hour}:${minute} ${period}";


  }



  void ContinueInfo() {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: backgroundCream,
            title: Text(
              "Complete Service Info",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                Text("You must complete your service information first!", style: TextStyle(fontWeight: FontWeight.bold)),


                SizedBox(height: 20,),



                /// Button
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                        onPressed: ()  {
                          Navigator.pop(context);
                          
                          Navigator.pushNamed((context), '/serviceprofile');
                          
                          

                        



                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryMaroon,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(120, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text("Continue", style: TextStyle(fontSize: 16)),
                      ),

                      SizedBox(width: 20,),



                    ],
                  ),
                ),
              ],
            ),
          );



        } );
  }

}