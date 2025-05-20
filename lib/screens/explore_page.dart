import 'package:cookpad_app_clone/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../models/food_model.dart';
import 'food_detail.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Food List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                    border: Border.all(color: Colors.grey, width: 1)
                  ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm món ăn...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('foods')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No food found.'));
                }
                // Filter foods by name
                final filteredDocs = docs.where((doc) {
                  final food = Food.fromFirestore(doc);
                  return food.name.toLowerCase().contains(searchQuery);
                }).toList();
                if (filteredDocs.isEmpty) {
                  return const Center(
                      child: Text('Không tìm thấy món ăn phù hợp.'));
                }
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final food = Food.fromFirestore(filteredDocs[index]);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetail(food: food),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF232323),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      food.description,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer,
                                            color: Colors.white54, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          food.time.isNotEmpty
                                              ? food.time
                                              : 'Không rõ',
                                          style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        food.authorAvatar?.isNotEmpty == true
                                            ? CircleAvatar(
                                                radius: 12,
                                                backgroundImage: NetworkImage(
                                                    food.authorAvatar!),
                                              )
                                            : const CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.grey,
                                                child: Icon(Icons.person,
                                                    size: 16,
                                                    color: Colors.white),
                                              ),
                                        const SizedBox(width: 8),
                                        Text(
                                          food.authorName ?? 'Ẩn danh',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    child: food.picture.isNotEmpty
                                        ? Image.network(
                                            food.picture,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) =>
                                                Container(
                                              width: 90,
                                              height: 90,
                                              color: Colors.grey,
                                              child: const Icon(Icons.image,
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Container(
                                            width: 90,
                                            height: 90,
                                            color: Colors.grey,
                                            child: const Icon(Icons.fastfood,
                                                color: Colors.white),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.bookmark_border,
                                            color: Colors.white),
                                        onPressed: () {},
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/home/explorePage/add-food-form');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: SizedBox(height: 80, child: BottomNavBar(currentIndex: 1)),
    );
  }
}