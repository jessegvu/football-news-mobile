import 'package:flutter/material.dart';
import 'package:football_news/screens/newslist_form.dart';
import 'package:football_news/screens/news_entry_list.dart';
import 'package:football_news/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
            );

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Add News") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewsFormPage(),
              ),
            );
          } else if (item.name == "See Football News") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewsEntryListPage(),
              ),
            );
          } else if (item.name == "Logout") {
            // Logout endpoint
            // For Android emulator: http://10.0.2.2:8000/auth/logout/
            // For Chrome/Web: http://localhost:8000/auth/logout/
            
            try {
              print('[DEBUG] Starting logout process...');
              
              final response = await request.logout(
                "http://localhost:8000/auth/logout/",
              );
              
              print('[DEBUG] Logout response: $response');
              
              if (context.mounted) {
                String message = response["message"] ?? "Logout successful!";
                bool status = response['status'] ?? false;
                
                print('[DEBUG] Response status: $status, Message: $message');
                
                if (status == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  // Navigate to login after logout
                  if (context.mounted) {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Logout failed: $message"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } catch (e) {
              print('[DEBUG] Logout error: ${e.toString()}');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error during logout: ${e.toString()}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}