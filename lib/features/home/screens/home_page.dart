import 'package:bloodbond_app/features/home/controllers/fetch_dontaions.dart';
import 'package:bloodbond_app/features/home/model/donation_model.dart';
import 'package:bloodbond_app/widgets/bottom-navbar.dart';
import 'package:flutter/material.dart';
import 'package:bloodbond_app/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<DonationModel> donations = [];
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isRefreshToken();
    notificationServices.getDeviceToken().then((value) {
      print("Device Token $value");
    });
    fetchDonations();
  }

  void fetchDonations() async {
    try {
      var fetchedDonations = await DonationRepository.instance.fetchDonations();
      setState(() {
        donations = fetchedDonations;
      });
    } catch (error) {
      // Handle error
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 236),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 198, 168, 105),
        title: Text(
          'NourishNet',
          style: TextStyle(
            fontSize: 35,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Food Servings: ${donations[index].foodServings}'),
              subtitle: Text('Timings: ${donations[index].timings}'),
              // Add any other fields you want to display on the card
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}
