import 'package:flutter/material.dart';
import 'package:flutter_nearfix/customerChat.dart';
import 'package:flutter_nearfix/customerNavbar.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Service extends StatefulWidget {
  String service_id;
  Service(this.service_id);

  @override
  State<Service> createState() => _ServiceState(service_id);
}

class _ServiceState extends State<Service> {
  String service_id;
  _ServiceState(this.service_id);

  final Color primaryMaroon = Color(0xFF5D1219);
  final Color backgroundCream = Color(0xFFF9F5EB);
  final Color accentSage = Color(0xFF9FB2AC);
  final Color textMaroon = Color(0xFF1A0101);
  DateTime displayedMonth = DateTime.now();
  int selectedDay = -1;
  DateTime? selectedDate;
  Map<String, dynamic>? selectedTime;
  List Morning = [];
  List AfterNoon = [];
  List Evening = [];
  final supa = Supabase.instance.client;
  List<String> monthsList = [
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
  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<String>? ourServices;

  List<String>? ServicesTypes;

  String? selectedService;

  List Data = [];
  List ListOfReviews = [];

  int selectingRating = 0;
  int sumOfRating = 0;
  double TotalRating = 0;

  TextEditingController feedbackController = TextEditingController();
  Map<String, dynamic>? serviceInfo;

  bool isLoading = true;

  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final response = await supa
        .from("provider_schedule")
        .select()
        .eq("service_id", service_id);

    final service = await supa
        .from("service")
        .select('''
    *,
    providers(full_name)
    ''')
        .eq("id", service_id)
        .single();

    final reviews = await supa
        .from("FeedBack")
        .select('''
      *,
      customers(full_name)
      ''')
        .eq("service_id", service_id);

    setState(() {
      Data = response;
      ListOfReviews = reviews;
      serviceInfo = service;
      ourServices = List<String>.from(service['category']);
      ServicesTypes = List<String>.from(service['List_service_type']);

      isLoading = false;
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ListOfReviews.isEmpty)
      TotalRating = 0;
    else {
      sumOfRating = 0;
      for (int i = 0; i < ListOfReviews.length; i++)
        sumOfRating = sumOfRating + ListOfReviews[i]['rating'] as int;
      TotalRating = sumOfRating / ListOfReviews.length;
    }

    if (isLoading) {
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
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 30, color: textMaroon),
        ),
        title: Text(
          'Service',
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${serviceInfo!['service_name']}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerChatScreen(
                              receiverId: serviceInfo!['provider_id'],
                              receiverName:
                              serviceInfo!['providers']['full_name'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryMaroon,
                      ),
                      child: Text(
                        "Chat",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Text(
                  "${serviceInfo!['location']}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  "${serviceInfo!['description']}",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    for (int i = 0; i < ourServices!.length; i++) ...[
                      Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 145,
                        decoration: BoxDecoration(
                          color: accentSage,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          ourServices![i],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book Appointment",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  width: 600,
                  height: 60,

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: DropdownButton(
                      value: selectedService,
                      hint: Text(
                        "Choose service name",
                        style: TextStyle(color: Colors.grey),
                      ),
                      underline: SizedBox(),
                      isExpanded: true,
                      items: ServicesTypes!.map<DropdownMenuItem<String>>((
                          String o,
                          ) {
                        return DropdownMenuItem(value: o, child: Text(o));
                      }).toList(),
                      onChanged: (o) {
                        setState(() {
                          selectedService = o!;
                        });
                      },
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              DateTime now = DateTime.now();
                              if (displayedMonth.year == now.year &&
                                  displayedMonth.month == now.month)
                                return;

                              setState(() {
                                displayedMonth = DateTime(
                                  displayedMonth.year,
                                  displayedMonth.month - 1,
                                  1,
                                );
                                selectedDay = -1;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_circle_left_outlined,
                              color: accentSage,
                            ),
                          ),
                          Text(
                            "${monthsList[displayedMonth.month - 1]} ${displayedMonth.year}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                displayedMonth = DateTime(
                                  displayedMonth.year,
                                  displayedMonth.month + 1,
                                  1,
                                );
                                selectedDay = -1;
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
                            displayedMonth.month + 1,
                            0,
                          ).day,
                          itemBuilder: (context, index) {
                            DateTime curruntDay = DateTime(
                              displayedMonth.year,
                              displayedMonth.month,
                              index + 1,
                            );
                            bool isSelected = selectedDay == index;

                            DateTime today = DateTime.now();
                            DateTime todayonly = DateTime(
                              today.year,
                              today.month,
                              today.day,
                            );
                            if (curruntDay.isBefore(todayonly)) {
                              return const SizedBox.shrink();
                            }

                            return GestureDetector(
                              onTap: () {
                                Morning.clear();
                                AfterNoon.clear();
                                Evening.clear();

                                for (var time in Data) {
                                  DateTime date = DateTime.parse(
                                    time["available_at"],
                                  );

                                  if (date.year == curruntDay.year &&
                                      date.month == curruntDay.month &&
                                      date.day == curruntDay.day) {
                                    if (date.hour < 12)
                                      Morning.add(time);
                                    else if (date.hour < 17)
                                      AfterNoon.add(time);
                                    else
                                      Evening.add(time);
                                  }
                                }

                                setState(() {
                                  selectedDay = index;
                                  selectedDate = curruntDay;
                                });
                              },
                              child: Container(
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
                                      days[curruntDay.weekday - 1],
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

                          // to check if there are an appointments or not
                          Morning.isEmpty
                              ? Center(
                            child: Text(
                              "No appointment available at this time",
                            ),
                          )
                              : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: Morning.length,

                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3 / 1,
                            ),
                            itemBuilder: (context, index) {
                              bool isbooked = Morning[index]["is_booked"];

                              bool isSelected =
                                  selectedTime != null &&
                                      selectedTime!["available_at"] ==
                                          Morning[index]["available_at"];

                              DateTime date = DateTime.parse(
                                Morning[index]["available_at"],
                              );

                              return GestureDetector(
                                onTap: () {
                                  if (isbooked) return;

                                  setState(() {
                                    selectedTime = Morning[index];
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isbooked
                                        ? Colors.grey
                                        : isSelected
                                        ? accentSage
                                        : Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "${formatTime(date)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AfterNoon:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          AfterNoon.isEmpty
                              ? Center(
                            child: Text(
                              "No appointment available at this time",
                            ),
                          )
                              : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: AfterNoon.length,

                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3 / 1,
                            ),
                            itemBuilder: (context, index) {
                              bool isbooked =
                              AfterNoon[index]["is_booked"];

                              bool isSelected =
                                  selectedTime != null &&
                                      selectedTime!["available_at"] ==
                                          AfterNoon[index]["available_at"];

                              DateTime date = DateTime.parse(
                                AfterNoon[index]["available_at"],
                              );

                              return GestureDetector(
                                onTap: () {
                                  if (isbooked) return;

                                  setState(() {
                                    selectedTime = AfterNoon[index];
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isbooked
                                        ? Colors.grey
                                        : isSelected
                                        ? accentSage
                                        : Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "${formatTime(date)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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

                          Evening.isEmpty
                              ? Center(
                            child: Text(
                              "No appointment available at this time",
                            ),
                          )
                              : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: Evening.length,

                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3 / 1,
                            ),
                            itemBuilder: (context, index) {
                              bool isbooked = Evening[index]["is_booked"];

                              bool isSelected =
                                  selectedTime != null &&
                                      selectedTime!["available_at"] ==
                                          Evening[index]["available_at"];

                              DateTime date = DateTime.parse(
                                Evening[index]["available_at"],
                              );

                              return GestureDetector(
                                onTap: () {
                                  if (isbooked) return;

                                  setState(() {
                                    selectedTime = Evening[index];
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isbooked
                                        ? Colors.grey
                                        : isSelected
                                        ? accentSage
                                        : Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "${formatTime(date)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedService == null || selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "please select both a service and type.",
                            ),
                          ),
                        );

                        return;
                      }

                      final user = supa.auth.currentUser;

                      final customerData = await supa
                          .from('customers')
                          .select('full_name')
                          .eq('id', user!.id)
                          .single();

                      await supa.from('appointments').insert({
                        'customer_id': user!.id,
                        'provider_id': selectedTime!['provider_id'],
                        'service_id': service_id,
                        'schedule_id': selectedTime!['id'],
                        'selected_service_type': selectedService,
                        'status': "pending",
                      });

                      await supa.from('notifications').insert({
                        'user_id': selectedTime!['provider_id'],
                        'title': 'New Appointment',
                        'description':
                        '${customerData['full_name']} booked your service',
                        'notification_type': 'appointment',
                        'is_read': false,
                      });

                      await supa
                          .from('provider_schedule')
                          .update({'is_booked': true})
                          .eq('id', selectedTime!["id"]);

                      setState(() {
                        _showPopup();
                        selectedTime!["is_booked"] = true;
                        selectedTime = null;
                        selectedService = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryMaroon,
                    ),
                    child: Text(
                      "Book now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rating & Reviews",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "${TotalRating.toStringAsFixed(1)}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.amber),
                      ],
                    ),
                  ],
                ),

                ListOfReviews.isEmpty
                    ? Center(
                  child: Text(
                    "There are no reviews yet.Be the first to leave a review!",
                  ),
                )
                    : Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ListOfReviews.length,

                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: backgroundCream,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/images.png',
                              ),
                              radius: 25,
                            ),
                            title: Text(
                              "${ListOfReviews[index]['customers']['full_name']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${ListOfReviews[index]['review']}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${ListOfReviews[index]['rating']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                if (supa.auth.currentUser!.id ==
                                    ListOfReviews[index]['customer_id'])
                                  IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        _showPopupfordeleteFeedBack(
                                          ListOfReviews[index]['id'],
                                        );
                                      });
                                    },
                                    icon: Icon(Icons.delete, size: 16),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Feedback",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectingRating == index + 1) {
                                selectingRating = 0;
                              } else {
                                selectingRating = index + 1;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            color: index < selectingRating
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(2),
                  child: TextField(
                    controller: feedbackController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "Write your feedback!",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 20),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(8),
                        child: IconButton(
                          onPressed: () async {
                            if (!feedbackController.text.trim().isEmpty) {
                              await supa.from('FeedBack').insert({
                                'customer_id': supa.auth.currentUser!.id,
                                'service_id': service_id,
                                'rating': selectingRating,
                                'review': feedbackController.text,
                              });

                              loadData();
                              feedbackController.clear();

                              setState(() {
                                selectingRating = 0;
                              });
                            }
                          },
                          icon: CircleAvatar(
                            backgroundColor: primaryMaroon,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: -1),
    );
  }

  void _showPopup() {
    DateTime date = DateTime.parse(selectedTime!["available_at"]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundCream,
          title: Text(
            "Service Booked Successfully!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Your appointment has been booked successfully for ${monthsList[date.month - 1]} ${date.day}, ${date.year} at ${formatTime(date)}.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 10),

              /// Button
              Center(
                child: ElevatedButton(
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
                  child: const Text("OK", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPopupfordeleteFeedBack(String feedBackID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundCream,
          title: Text(
            "Delete Review",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to delete this review?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              /// Button
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await supa
                            .from("FeedBack")
                            .delete()
                            .eq("id", feedBackID)
                            .eq('customer_id', supa.auth.currentUser!.id);
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
                      child: const Text(
                        "Delete",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    SizedBox(width: 20),

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
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatTime(DateTime date) {
    int hour = date.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return "${hour}:${date.minute.toString().padLeft(2, '0')} ${period}";
  }
}