import 'package:flutter/material.dart';
import 'db_helper.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final DBHelper dbHelper = DBHelper();

  Future<void> _removeBookmark(int id) async {
    await dbHelper.deleteFavorite(id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bookmark removed")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookmarks")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var bookmarks = snapshot.data!;
          if (bookmarks.isEmpty) return Center(child: Text("No bookmarks yet"));

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              var place = bookmarks[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(Icons.place),
                  title: Text(place["name"]),
                  subtitle: Text("Lat: ${place["lat"]}, Lng: ${place["lng"]}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Confirm before deleting
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete Bookmark"),
                          content: Text("Are you sure you want to delete ${place["name"]}?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () {
                                Navigator.pop(context);
                                _removeBookmark(place["id"]); // uses id to delete
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
