import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB6C1), // Pink
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF0F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFB6C1),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFD72660),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          iconTheme: IconThemeData(color: Color(0xFFD72660)),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFB23A48)),
        ),
        cardColor: Color(0xFFFFE4EC),
        useMaterial3: true,
      ),
      home: RecipesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Recipe {
  final int id;
  final String name;
  final String image;

  Recipe({required this.id, required this.name, required this.image});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
    );
  }
}

class RecipesService {
  static const String apiUrl = 'https://dummyjson.com/recipes';

  static Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> recipesJson = data['recipes'];
      return recipesJson.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  late Future<List<Recipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = RecipesService.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เมนูอาหาร'),
        leading: const Icon(Icons.favorite, color: Color(0xFFD72660)),
        actions: [Padding(padding: const EdgeInsets.only(right: 16))],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD72660)),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken, size: 48, color: Color(0xFFD72660)),
                  const SizedBox(height: 16),
                  Text(
                    'เกิดข้อผิดพลาด',
                    style: TextStyle(fontSize: 18, color: Color(0xFFB23A48)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 48,
                    color: Color(0xFFD72660),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ไม่พบข้อมูลเมนูอาหาร',
                    style: TextStyle(fontSize: 16, color: Color(0xFFB23A48)),
                  ),
                ],
              ),
            );
          }
          final recipes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                elevation: 6,
                color: const Color(0xFFFFE4EC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          bottomLeft: Radius.circular(22),
                        ),
                        child: recipe.image.isNotEmpty
                            ? Image.network(
                                recipe.image,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 110,
                                      height: 110,
                                      color: Color(0xFFFFB6C1),
                                      child: const Icon(
                                        Icons.fastfood,
                                        size: 40,
                                        color: Color(0xFFD72660),
                                      ),
                                    ),
                              )
                            : Container(
                                width: 110,
                                height: 110,
                                color: Color(0xFFFFB6C1),
                                child: const Icon(
                                  Icons.fastfood,
                                  size: 40,
                                  color: Color(0xFFD72660),
                                ),
                              ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD72660),
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    size: 18,
                                    color: Color(0xFFFFB6C1),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Recipe ID: ${recipe.id}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFB23A48),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
