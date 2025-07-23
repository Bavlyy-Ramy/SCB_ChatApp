import 'package:awesome_icons/awesome_icons.dart';
import 'package:chat_app/feature/chat/data/data_sources/dummy_users.dart';
import 'package:chat_app/feature/chat/presentation/pages/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List dummyList;

  @override
  void initState() {
    super.initState();
    dummyList = List.from(dummyUsers); 
  }

  void _deleteUser(int index) {
    final deletedUser = dummyList[index];
    setState(() {
      dummyList.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${deletedUser.name} deleted')),
    );
  }

  void _pinUser(int index) {
    final pinnedUser = dummyList[index];
    setState(() {
      dummyList.removeAt(index);
      dummyList.insert(0, pinnedUser); // move to top
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pinnedUser.name} pinned to top')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilterButtons(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyList.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(dummyList[index].id),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => _pinUser(index),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: FontAwesomeIcons.mapPin,
                        label: 'Pin',
                      ),
                      SlidableAction(
                        onPressed: (_) => _showDeleteConfirmation(index),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ChatTile(user: dummyList[index]),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF00BF6C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00BF6C),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Chat"),
        content:
            Text("Are you sure you want to delete ${dummyList[index].name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(index);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF00BF6C),
      title: const Text(
        'Chats',
        style: TextStyle(color: Colors.white, fontSize: 26),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.white, size: 28),
        )
      ],
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              onPressed: () {},
              child: const Text("Recent Message"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BF6C),
                shape: const StadiumBorder(),
              ),
              onPressed: () {},
              child: const Text("Active"),
            ),
          ),
        ],
      ),
    );
  }
}
