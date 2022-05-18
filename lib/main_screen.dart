import 'package:flutter/material.dart';
import 'package:luri_resto_app/detail_screen.dart';
import 'package:luri_resto_app/model/local_restaurant.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Luri Resto App',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.yellow,
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      showSearch<String>(
                        context: context,
                        delegate: CustomDelegate(),
                      );
                    },
                    child: const Icon(
                      Icons.search,
                      size: 26.0,
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth <= 600) {
                return const LocalRestaurantList();
              } else if (constraints.maxWidth <= 1200) {
                return const LocalRestaurantList();
              } else {
                return const LocalRestaurantList();
              }
            },
          ),
        );
      },
    );
  }
}

class LocalRestaurantList extends StatefulWidget {
  const LocalRestaurantList({Key? key}) : super(key: key);

  @override
  State<LocalRestaurantList> createState() => _LocalRestaurantListState();
}

class _LocalRestaurantListState extends State<LocalRestaurantList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final restaurant = localRestaurantList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailScreen(restaurant: restaurant);
                    }));
                  },
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Image.network(restaurant.pictureId)),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant.name,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        const SizedBox(width: 4),
                                        Text(
                                          restaurant.city,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star),
                                        const SizedBox(width: 4),
                                        Text(
                                          restaurant.rating.toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
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
              itemCount: localRestaurantList.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<String> {
  List<String> restaurantsName = getRestaurantNameList(getRestaurantData());
  var restaurants = getRestaurantData();

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List listToShow;
    List listRestaurant;
    List tempListName = [];
    List tempList = [];
    if (query.isNotEmpty) {
      for (var restaurant in restaurants) {
        if (restaurant.name.toLowerCase().contains(query.toLowerCase())) {
          tempListName.add(restaurant.name);
          tempList.add(restaurant);
        }
      }
      listToShow = tempListName;
      listRestaurant = tempList;
    } else {
      listToShow = restaurantsName;
      listRestaurant = restaurants;
    }

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var item = listRestaurant[i];
        return ListTile(
          title: Text(item.name),
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailScreen(restaurant: item);
            }))
          },
        );
      },
    );
  }
}
