import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manajemen_aset/screen/creat_aset_screen.dart';
import 'package:manajemen_aset/screen/detail_aset_screen.dart';
import 'package:manajemen_aset/screen/login_screen.dart';
import 'package:manajemen_aset/utilis/api_config.dart';
import 'package:provider/provider.dart';

import 'data_service.dart';
import 'firebase_options.dart';
import 'models/user.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, // Ubah warna ikon di AppBar
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataService dataService = DataService();
  late Future<List<dynamic>> _futureData;

  Future<List<dynamic>> _loadData() {
    return dataService
        .selectAll(token, project, collection, appId)
        .then((value) => jsonDecode(value));
  }

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        userProvider.setCurrentUser;
        final user = userProvider.currentUser;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureData = _loadData();
              });
            },
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Explore'),
                  actions: [
                    IconButton(
                      onPressed: () => _signOut(context),
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
                body: FutureBuilder<List<dynamic>>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data.'));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var aset = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListTile(
                                visualDensity: VisualDensity(vertical: 3),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 9),
                                leading: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          fileUri + aset['gambar']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(aset['nama'] ?? ''),
                                subtitle: Text(aset['kategori'] ?? ''),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailAsetScreen(
                                        aset: aset,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                floatingActionButton: Provider.of<UserProvider>(context)
                            .currentUser!
                            .role ==
                        Role.admin
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TambahAsetScreen()),
                          );
                        },
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.add, color: Colors.white),
                      )
                    : null),
          );
        }
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog
                // Panggil fungsi _signOut untuk logout
                try {
                  await FirebaseAuth.instance.signOut();

                  // Hapus data user dari state management (jika ada)
                  Provider.of<UserProvider>(context, listen: false)
                      .setCurrentUser(null);

                  // Navigasi ke halaman login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } catch (e) {
                  // Tangani error
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal logout.')),
                  );
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
