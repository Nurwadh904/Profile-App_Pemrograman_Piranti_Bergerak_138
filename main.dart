import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _scaled = false;

  void _toggleTheme() {
    setState(() {
      _scaled = true;
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _scaled = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Diri Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        cardColor: const Color(0xFF1D1E33).withOpacity(0.95),
      ),
      themeMode: _themeMode,
      home: MahasiswaProfile(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
        scaled: _scaled,
      ),
    );
  }
}

class MahasiswaProfile extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final bool scaled;

  const MahasiswaProfile({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
    required this.scaled,
  });

  @override
  State<MahasiswaProfile> createState() => _MahasiswaProfileState();
}

class _MahasiswaProfileState extends State<MahasiswaProfile> {
  bool showContent = false;

  // 🔹 jumlah data = 10 item biodata
  List<bool> showTile = List.generate(10, (_) => false);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => showContent = true);
    });

    for (int i = 0; i < showTile.length; i++) {
      Future.delayed(Duration(milliseconds: 800 + (i * 300)), () {
        if (mounted) {
          setState(() => showTile[i] = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Diri Mahasiswa"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double avatarRadius = screenWidth < 600 ? 55 : 90;
          double titleFontSize = screenWidth < 600 ? 24 : 32;
          double subtitleFontSize = screenWidth < 600 ? 16 : 20;
          double paddingCard = screenWidth < 600 ? 20 : 40;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF0F2027),
                        const Color(0xFF203A43),
                        const Color(0xFF2C5364)
                      ]
                    : [
                        const Color(0xFF2193b0),
                        const Color(0xFF6dd5ed),
                        const Color(0xFFcc2b5e)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: AnimatedScale(
                  scale: widget.scaled ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: showContent ? 1 : 0,
                    duration: const Duration(milliseconds: 700),
                    child: AnimatedSlide(
                      offset: showContent ? Offset.zero : const Offset(0, 0.3),
                      duration: const Duration(milliseconds: 700),
                      child: Card(
                        elevation: 16,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(paddingCard),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.purpleAccent],
                                  ),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundColor: Colors.transparent,
                                  child: const Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                "Nurwadah",
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: isDark
                                      ? Colors.blue.shade200
                                      : Colors.blue.shade900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Informatika",
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? Colors.blue.shade100
                                      : Colors.blue.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),

                              // 🔹 Biodata
                              buildAnimatedTile(
                                  0, Icons.badge, "NIM", "2309106138", isDark),
                              const SizedBox(height: 16),
                              buildAnimatedTile(2, Icons.apartment, "Fakultas",
                                  "Teknik", isDark),
                              const SizedBox(height: 16),
                              buildAnimatedTile(3, Icons.email, "Email",
                                  "nurwadah25@gmail.com", isDark),
                              const SizedBox(height: 16),

                              // 🔹 Instagram
                              buildAnimatedTile(4, Icons.camera_alt, "Instagram",
                                  "@nurwadah1", isDark,
                                  url: "https://instagram.com/nurwadah1"),
                              const SizedBox(height: 16),

                              buildAnimatedTile(5, Icons.cake, "Tanggal Lahir",
                                  "1 Juni 2005", isDark),
                              const SizedBox(height: 16),
                              buildAnimatedTile(6, Icons.phone, "No. HandPhone",
                                  "+62 821-4648-0682", isDark),
                              const SizedBox(height: 30),
                              Text(
                                "\"Belajar Coding Itu Seru.\"",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? Colors.blueGrey.shade200
                                      : Colors.blueGrey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAnimatedTile(int index, IconData icon, String title,
      String subtitle, bool isDark,
      {String? url}) {
    return AnimatedOpacity(
      opacity: showTile[index] ? 1 : 0,
      duration: const Duration(milliseconds: 600),
      child: AnimatedSlide(
        offset: showTile[index] ? Offset.zero : const Offset(0.2, 0),
        duration: const Duration(milliseconds: 600),
        child: _InteractiveTile(
          icon: icon,
          title: title,
          subtitle: subtitle,
          isDark: isDark,
          url: url,
        ),
      ),
    );
  }
}

class _InteractiveTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final String? url;

  const _InteractiveTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.url,
  });

  @override
  State<_InteractiveTile> createState() => _InteractiveTileState();
}

class _InteractiveTileState extends State<_InteractiveTile> {
  bool _isHovering = false;
  bool _isTapped = false;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovering ? -5.0 : 0.0)
            ..scale(_isTapped ? 0.97 : 1.0)
            ..rotateZ(_isHovering ? 0.02 : 0.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isDark
                  ? [Colors.blueGrey.shade800, Colors.deepPurple.shade700]
                  : [
                      Colors.blue.shade400,
                      Colors.cyan.shade400,
                      Colors.purpleAccent
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: widget.isDark
                    ? Colors.blueAccent.withOpacity(_isHovering ? 0.7 : 0.3)
                    : Colors.purple.withOpacity(_isHovering ? 0.6 : 0.3),
                blurRadius: _isHovering ? 18 : 8,
                spreadRadius: _isHovering ? 2 : 0,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white24,
            onTap: () {
              if (widget.url != null) {
                _launchURL(widget.url!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.title}: ${widget.subtitle}"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: ListTile(
              leading: Icon(widget.icon, color: Colors.white, size: 28), // 🔹 bigger icon
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20, // 🔹 bigger font
                ),
              ),
              subtitle: Text(
                widget.subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18, // 🔹 bigger font
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 24, // 🔹 bigger arrow
              ),
            ),
          ),
        ),
      ),
    );
  }
}
