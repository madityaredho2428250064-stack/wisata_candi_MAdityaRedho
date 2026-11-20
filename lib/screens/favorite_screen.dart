import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/candi_data.dart';
import '../models/candi.dart';
import '../widgets/item_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Candi> favoriteList = [];

  // TODO: 1. Mengambil data candi yang difavoritkan
  Future<void> loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    List<Candi> favorites = [];

    for (final candi in candiList) {
      final isFavorite = prefs.getBool('favorite_${candi.name}') ?? false;

      if (isFavorite) {
        favorites.add(candi);
      }
    }

    if (!mounted) return;

    setState(() {
      favoriteList = favorites;
    });
  }

  @override
  void initState() {
    super.initState();
    loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Candi Favorit')),
      body: favoriteList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 70, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada candi favorit',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                final Candi candi = favoriteList[index];
                return ItemCard(candi: candi, onReturn: loadFavorite);
              },
            ),
    );
  }
}
