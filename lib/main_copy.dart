import 'package:flutter/material.dart';
import 'package:rmart/data_search.dart';


/*
List of replaced classes:
  FlatButton → TextButton
  RaisedButton → ElevatedButton
  OutlineButton → OutlinedButton
  ButtonTheme → TextButtonTheme, ElevatedButtonTheme, OutlineButtonTheme
*/

void main() => runApp(MaterialApp(
  home: MyApp(),
  debugShowCheckedModeBanner: false,
));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name = 'Shyam Srinivasan';
  String email = '220701508@rajalakshmi.edu.in';
  double volume = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Hides the default menu drawer icon
        title: Stack(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 4),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: const Text(
                    'Rec Hut',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(34.5, 20),
              child: InkWell(
                onTap: () {
                  print('Switch Shop');
                },
                child: const Text(
                  'Switch Shop',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Builder( // Use Builder to get a context under the Scaffold
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Opens the end drawer
                },
                icon: const Icon(Icons.person),
                color: Colors.deepPurple,
                iconSize: 30,
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            height: 4.0,
            thickness: 1,
            color: Color(0x61693BB8),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Adjust this value for more or less space from the top
        child: Align(
          alignment: Alignment.topCenter, // Aligns the search bar at the top middle
          child: InkWell(
            overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },

            child: Container(
              height: 50.0,
              width: 380.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                      color: Colors.grey,
                      width: 0.5
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 0),

                    )
                  ]
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],


              ),
            ),
          ),
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          )
        ],
        onTap: (int index) {
          print(index.toString());
        },
      ),

      endDrawer: const Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Shyam Srinivasan'),
              accountEmail: Text('220701508@rajalakshmi.edu.in'),
              currentAccountPicture: ClipOval(
                child: Image(
                  image: AssetImage('assets/img/Shyam_photo.jpg'),
                  fit: BoxFit.cover,

                ),
              ),
              /* currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),*/
            ),
            ListTile(
              title: Text('Favorites'),
              leading: Icon(Icons.favorite, color: Colors.pink),
            ),
            ListTile(
              title: Text('Order History'),
              leading: Icon(Icons.history),
            ),
            ListTile(
              title: Text('Feedback'),
              leading: Icon(Icons.feedback),
            ),
            ListTile(
              title: Text('About Us'),
              leading: Icon(Icons.info),
            ),
          ],
        ),
      ),
    );
  }
}
