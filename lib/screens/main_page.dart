// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'favorite_facts_page.dart';
import 'favorites_database.dart';
import 'dart:ui';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  List<String> favoriteFacts = [];
  final db = FavoritesDatabase();
  late Future<List> futureFacts;

  PageController pageController = PageController();
  int currentPage = 0;

  late String currentBackgroundImage;
  late Color primaryColor;
  late Color secondaryColor;
  late Color thirdColor;

  
  bool isDarkTheme = false; // Initial theme is light


  @override
  void initState() {
    super.initState();
    futureFacts = fetchFacts();
    _initializeTheme();
  }

  void _initializeTheme() {
  if (isDarkTheme) {
    currentBackgroundImage = "lib/assets/wp3354900.jpg";
    primaryColor = Color.fromARGB(255, 62, 37, 73);
    secondaryColor = Color(0xFF1B0D1E);
    thirdColor = Color.fromARGB(255, 199, 199,199);// Change the icon col
  } else {
    currentBackgroundImage = "lib/assets/wp4464921.jpg";
    primaryColor = Color.fromARGB(255, 255, 137, 172);
    secondaryColor = Color.fromARGB(255, 253, 162, 189);
    thirdColor = Color.fromARGB(255, 230, 90, 90);
  }
  }

  void toggleTheme() {
  setState(() {
    isDarkTheme = !isDarkTheme;
    _initializeTheme();
  });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  

  void loadFavorites() async {
    favoriteFacts = await db.getFavorites();
  }

  void toggleFavorite(String fact) async {
    if (favoriteFacts.contains(fact)) {
      await db.deleteFavorite(fact);
      favoriteFacts.remove(fact);
    } else {
      await db.saveFavorite(fact);
      favoriteFacts.add(fact);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white), // Change this to your desired color
        title: const Text(
          'SwipeNLearn',
          style: TextStyle(
            color: Color.fromARGB(
                255, 255, 255, 255), // Change this to your desired color
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: Drawer(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor,
                    secondaryColor,
                  ], // Replace with your desired colors
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10)),
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            BorderRadius.circular(10), // Adjust as needed
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.5), // Shadow color
                            spreadRadius: 5, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: const Offset(
                                0, 3), // Changes position of shadow
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Favorites',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.circular(15), // Adjust as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset:
                              const Offset(0, 3), // Changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: Color.fromARGB(255, 255, 255, 255), // Change the icon color to white
                      ),
                      title: const Text(
                        'Favorite Facts',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255), // Change the title color to white
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onTap: () {
                        //Navigate to the favorite facts page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoriteFactsPage(currentbackground: currentBackgroundImage, primarycolor: thirdColor, secondarycolor: secondaryColor,),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10), // Add space between the items
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.circular(15), // Adjust as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5), // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset:
                              const Offset(0, 3), // Changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.brightness_6,
                        color: Color.fromARGB(255, 255, 255, 255), // Change the icon color to white
                      ),
                      title: const Text(
                        'Change Theme',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255), // Change the title color to white
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onTap: () {toggleTheme();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(currentBackgroundImage), // replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List>(
          future: futureFacts,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  PageView.builder(
                    controller: pageController,
                    itemCount: snapshot.data!.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.7,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromARGB(255, 95, 95, 95)
                                    .withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 34, 34, 34)
                                      .withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons
                                          .format_quote, // This is the quote icon
                                      size:
                                          40, // You can adjust the size as needed

                                      color: Colors
                                          .white, // You can adjust the color as needed
                                    ),
                                    Text(
                                      snapshot.data![index]['fact'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height:
                                          60, // You can adjust this value as needed
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: IconButton(
                                        icon: Icon(
                                          favoriteFacts.contains(snapshot
                                                  .data![currentPage]['fact'])
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: thirdColor,
                                          size: 40,
                                        ),
                                        onPressed: () => toggleFavorite(snapshot
                                            .data![currentPage]['fact']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<List> fetchFacts() async {
  String jsonString = await rootBundle.loadString("lib/assets/facts.json");
  Map<String, dynamic> jsonData = jsonDecode(jsonString);
  List facts = jsonData['funFacts'];
  facts.shuffle();
  return facts;
}
