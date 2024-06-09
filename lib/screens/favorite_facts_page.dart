import 'package:flutter/material.dart';
import 'favorites_database.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class FavoriteFactsPage extends StatefulWidget {

  final String currentbackground;
  final Color primarycolor;
  final Color secondarycolor;

  const FavoriteFactsPage({super.key,
    required this.currentbackground,
    required this.primarycolor,
    required this.secondarycolor,});


  @override
  // ignore: library_private_types_in_public_api
  _FavoriteFactsPageState createState() => _FavoriteFactsPageState();
}

class _FavoriteFactsPageState extends State<FavoriteFactsPage> {
  late Future<List<String>> futureFavorites;
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    futureFavorites = FavoritesDatabase.instance.getFavorites();
    pageController.addListener(() {
      currentPage = pageController.page!.round();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void removeFavorite(String fact) async {
    await FavoritesDatabase.instance.deleteFavorite(fact);
    setState(() {
      futureFavorites = FavoritesDatabase.instance.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // this is important
      appBar: AppBar(
        title: const Text(
          'Favorite Facts',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: const Color.fromARGB(255, 199, 199, 199),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.currentbackground), // replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: futureFavorites,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('No favorite facts'))
                  : Stack(
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
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1.5,
                                      color:
                                          const Color.fromARGB(255, 92, 92, 92)
                                              .withOpacity(0.3),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Icon(
                                            Icons.format_quote,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            snapshot.data![index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 60,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: widget.primarycolor,
                                                size: 40,
                                              ),
                                              onPressed: () => removeFavorite(
                                                  snapshot.data![currentPage]),
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
