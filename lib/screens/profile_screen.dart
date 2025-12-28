import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/profile_view_model.dart';
import '../../viewmodel/auth_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final user = FirebaseAuth.instance.currentUser;

    
  });
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthViewModel>(context, listen: false).signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          if (vm.profile == null) return const Center(child: Text("No profile found"));

          final p = vm.profile!;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${p.name}", style: const TextStyle(fontSize: 20)),
                Text("Email: ${p.email}", style: const TextStyle(fontSize: 20)),
                Text("Age: ${p.age}", style: const TextStyle(fontSize: 18)),
                Text("Workouts: ${p.totalWorkouts}", style: const TextStyle(fontSize: 18)),
                Text("Distance: ${p.totalDistance} km", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => _showEditNameDialog(context, vm, p),
                  child: const Text("Edit Name"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, ProfileViewModel vm, profile) {
    final controller = TextEditingController(text: profile.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await vm.updateName(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
