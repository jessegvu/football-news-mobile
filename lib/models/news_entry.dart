// To parse this JSON data, do
//
//     final newsEntry = newsEntryFromJson(jsonString);

import 'dart:convert';

List<NewsEntry> newsEntryFromJson(String str) => List<NewsEntry>.from(json.decode(str).map((x) => NewsEntry.fromJson(x)));

String newsEntryToJson(List<NewsEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsEntry {
    final int id;
    final String title;
    final String content;
    final String category;
    final String? thumbnail;
    final bool isFeatured;
    final String dateCreated;
    final String user;

    NewsEntry({
        required this.id,
        required this.title,
        required this.content,
        required this.category,
        this.thumbnail,
        required this.isFeatured,
        required this.dateCreated,
        required this.user,
    });

    factory NewsEntry.fromJson(Map<String, dynamic> json) {
        return NewsEntry(
          id: json['id'] ?? 0,
          title: json['title'] ?? 'No Title',
          content: json['content'] ?? 'No Content',
          category: json['category'] ?? 'unknown',
          thumbnail: json['thumbnail'],
          isFeatured: json['is_featured'] ?? false,
          dateCreated: json['date_created'] ?? '',
          user: json['user'] ?? 'Unknown',
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "category": category,
        "thumbnail": thumbnail,
        "is_featured": isFeatured,
        "date_created": dateCreated,
        "user": user,
    };
}
