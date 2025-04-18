import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:audioplayers/audioplayers.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyC7OGyS_spv8epMacjACpdWO2pWO-rENT4",
      appId: "597340607911",
      messagingSenderId: "597340607911",
      projectId: "assignment3-4f6dd")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Icon(Icons.flutter_dash), decoration: BoxDecoration(color: Colors.orange),),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                trailing: IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfilePage()));
                }, icon: Icon(Icons.arrow_right)),
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                trailing: IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NotifitcationsPage()));
                }, icon: Icon(Icons.arrow_right)),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                trailing: IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SettingsPage()));
                }, icon: Icon(Icons.arrow_right)),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Log Out'),
                trailing: IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LogOutPage()));
                }, icon: Icon(Icons.arrow_right)),
              ),
            ],
          )
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _tasks = FirebaseFirestore.instance.collection('Tasks').snapshots();
  final CollectionReference tasks = FirebaseFirestore.instance.collection("Tasks");

  String taskName = "";
  Future<void> addTask(String userId, String taskName) async{
    try {

    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTask(String userId) async {
    try {
      await tasks.doc(userId).delete();
      print('Task has been deleted');
    } catch (e) {
      print(e);
    }
  }

  void createTask(String taskName) async {
    try {
      await tasks.add({
        "taskName": taskName,
        "created": DateTime.now()
      });
      setState(() {
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CloudFirestoreExample'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder<QuerySnapshot>(stream: _tasks, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasError){
              return Text('Error has been made');
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                String docId = document.id;
                return ListTile(
                  title: Text(data['taskName']),
                  subtitle: Text(
                      (data['created'] as Timestamp).toDate().toString()
                  ),
                  trailing: ElevatedButton(onPressed: () {
                    deleteTask(docId);
                  }, child: Icon(Icons.delete, color: Colors.red)));
              }).toList(),
            );
          }
          )
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: Expanded(child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Task Name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                      ),
                    ),
                    onChanged: (value) {
                      taskName = value;
                    },
                  ) ),
                ),
                ElevatedButton(onPressed: () {
                  createTask(taskName);
                }, child: Text('ADD'), style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)
                  )
                ),)
              ],
            ),
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}

class NotifitcationsPage extends StatefulWidget {
  const NotifitcationsPage({super.key});

  @override
  State<NotifitcationsPage> createState() => _NotifitcationsPageState();
}

class _NotifitcationsPageState extends State<NotifitcationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search Here',
            filled: true,
            fillColor: Colors.white
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://m.media-amazon.com/images/I/81AHTyq2wVL._SL1500_.jpg",
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              // Right side: Title + Badge + Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Coffeehouse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 50% OFF Badge
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '50%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // MRP & Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'M.R.P: ₹1500.0',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Price: ₹1',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Additional notification (example)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://m.media-amazon.com/images/I/81AHTyq2wVL._SL1500_.jpg",
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              // Right side: Title + Badge + Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Coffeehouse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 50% OFF Badge
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '50%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // MRP & Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'M.R.P: ₹1500.0',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Price: ₹1',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://m.media-amazon.com/images/I/81AHTyq2wVL._SL1500_.jpg",
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),

              // Right side: Title + Badge + Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Coffeehouse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 50% OFF Badge
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '50%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // MRP & Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'M.R.P: ₹1500.0',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Price: ₹1',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}



class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void playSound(int soundNumber) async{
    final player = AudioPlayer();
    await player.play(AssetSource('note$soundNumber.wav'));
  }

  Expanded buildKey({required Color color, required int soundNumber}) {
    return Expanded(
      child: TextButton(
        onPressed: () => playSound(soundNumber),
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: const SizedBox.shrink(), // keep it empty, it's just a colored key
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: 
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.keyboard_return, color: Colors.white,)),
          title: Text('Flutter Xylophone',
            style: TextStyle(color: Colors.white),),
          centerTitle: true, backgroundColor: Colors.black,),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildKey(color: Colors.red, soundNumber: 1),
            buildKey(color: Colors.orange, soundNumber: 2),
            buildKey(color: Colors.yellow, soundNumber: 3),
            buildKey(color: Colors.green, soundNumber: 4),
            buildKey(color: Colors.teal, soundNumber: 5),
            buildKey(color: Colors.blue, soundNumber: 6),
            buildKey(color: Colors.purple, soundNumber: 7),
          ],
        ),
      ),
    );
  }
}

class LogOutPage extends StatefulWidget {
  const LogOutPage({super.key});

  @override
  State<LogOutPage> createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.keyboard_return)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have been LOGGED OUT', style: TextStyle(fontSize: 25),),
          ],
        ) ,
      )
    );
  }
}