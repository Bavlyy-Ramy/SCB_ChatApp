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
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    dummyList = List.from(dummyUsers);
  }

  void _deleteUser(int index) {
    final deletedUser = _filteredList()[index];
    setState(() {
      dummyList.removeWhere((user) => user.id == deletedUser.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${deletedUser.name} deleted')),
    );
  }

  void _pinUser(int index) {
    final pinnedUser = _filteredList()[index];
    setState(() {
      dummyList.removeWhere((user) => user.id == pinnedUser.id);
      dummyList.insert(0, pinnedUser);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pinnedUser.name} pinned to top')),
    );
  }

  List _filteredList() {
    if (searchQuery.isEmpty) return dummyList;
    return dummyList
        .where((user) =>
            user.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredList();

    return Scaffold(
      appBar: isSearching ? _buildSearchBar() : _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilterButtons(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(filtered[index].id),
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
                  child: ChatTile(user: filtered[index]),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF00BF6C),
      title: const Text('Chats',
          style: TextStyle(color: Colors.white, fontSize: 26)),
      actions: [
        IconButton(
          onPressed: () {
            setState(() => isSearching = true);
          },
          icon: const Icon(Icons.search, color: Colors.white, size: 28),
        )
      ],
    );
  }

  AppBar _buildSearchBar() {
    return AppBar(
      backgroundColor: const Color(0xFF00BF6C),
      title: TextField(
        controller: searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() => searchQuery = value);
        },
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          setState(() {
            isSearching = false;
            searchQuery = '';
            searchController.clear();
          });
        },
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    final user = _filteredList()[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Chat"),
        content: Text("Are you sure you want to delete ${user.name}?"),
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
