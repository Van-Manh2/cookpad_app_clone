import 'package:cookpad_app_clone/services/recipe_service.dart';
import 'package:cookpad_app_clone/utils/app_routes.dart';
import 'package:cookpad_app_clone/widgets/home_screen/recent_search.dart';
import 'package:flutter/material.dart';
import 'package:cookpad_app_clone/models/search.dart';
import 'package:cookpad_app_clone/services/search_service.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistorySearchScreen extends StatefulWidget {
  const HistorySearchScreen({super.key});

  @override
  State<HistorySearchScreen> createState() => _HistorySearchScreenState();
}

class _HistorySearchScreenState extends State<HistorySearchScreen> {
  final SearchService _searchService = SearchService();
  final RecipeService _recipeService = RecipeService();

  late Future<List<Search>> _searchesFuture;

  @override
  void initState() {
    super.initState();
    _searchesFuture = _searchService.getSearchHistory();
  }

  Future<void> _refreshSearches() async {
    setState(() {
      _searchesFuture = _searchService.getAllSearches();
    });
  }

  void _clearAllSearches() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Xóa tất cả?'),
            content: Text(
              'Bạn có chắc muốn xóa toàn bộ lịch sử tìm kiếm không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Xóa'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      await _searchService.clearAllSearches();
      _refreshSearches();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        context.go(AppRoutes.home);
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 350,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      child: Center(
                        child: TextField(
                          onTap: () {
                            context.go('${AppRoutes.home}/search');
                          },
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Gõ vào tên các nguyên liệu...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            prefixIcon: Icon(Icons.search, size: 20),
                            prefixIconColor: Colors.white,
                            isCollapsed: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: _clearAllSearches,
                      icon: Icon(Icons.delete_forever, color: Colors.white),
                      tooltip: 'Xóa toàn bộ',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 400,
                child: FutureBuilder<List<Search>>(
                  future: _searchesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Center(child: Text('Không thể tải lịch sử'));
                    } else if (snapshot.data!.isEmpty) {
                      return Center(child: Text('Chưa có tìm kiếm nào'));
                    }
                
                    final searches = snapshot.data!;
                    return ListView.builder(
                      itemCount: searches.length,
                      itemBuilder: (context, index) {
                        final search = searches[index];
                        return RecentSearch(search: search);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
