import 'package:flutter/material.dart';
import 'package:football_news/models/news_entry.dart';
import 'package:football_news/widgets/left_drawer.dart';
import 'package:football_news/widgets/news_entry_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  late Future<List<NewsEntry>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  Future<List<NewsEntry>> fetchNews() async {
    final request = context.read<CookieRequest>();
    
    try {
      print('[DEBUG] Fetching news from: http://localhost:8000/main/json/');
      
      final response = await request.get(
        'http://localhost:8000/main/json/',
      );

      print('[DEBUG] Response received: $response');
      print('[DEBUG] Response type: ${response.runtimeType}');

      if (response['status'] == true) {
        List<NewsEntry> newsList = [];
        
        for (var item in response['data']) {
          print('[DEBUG] Processing news item: ${item['title']}');
          newsList.add(NewsEntry.fromJson(item));
        }
        
        print('[DEBUG] Total news fetched: ${newsList.length}');
        return newsList;
      } else {
        print('[DEBUG] Response status is false: ${response['message']}');
        throw Exception(response['message'] ?? 'Failed to load news');
      }
    } catch (e) {
      print('[DEBUG] Error fetching news: ${e.toString()}');
      throw Exception('Failed to load news: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football News'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<NewsEntry>>(
        future: futureNews,
        builder: (context, snapshot) {
          print('[DEBUG] FutureBuilder state: ${snapshot.connectionState}');
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print('[DEBUG] Error in FutureBuilder: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureNews = fetchNews();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No news available'),
            );
          } else {
            List<NewsEntry> newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return NewsEntryCard(news: newsList[index]);
              },
            );
          }
        },
      ),
    );
  }
}