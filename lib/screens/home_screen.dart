import 'package:fit_quest/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';
import 'dashboard_screen.dart';
import 'gps_workout_screen.dart';

import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> pages = [
    const DashboardScreen(),
    const WorkoutScreen(),
    
    const GPSWorkoutScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FitQuest"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthViewModel>(context, listen: false).signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
        
      ),

      body: pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: 
      const Color.fromARGB(255, 255, 255, 255),
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
         selectedItemColor: Colors.blue,      // visible color when selected
  unselectedItemColor: const Color.fromARGB(118, 158, 158, 158),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Workouts",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.gps_fixed),
              label: "GPS Track",
        ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
