import 'package:flutter/material.dart';

void main() {
  runApp(const MyAppWeek3());
}

class MyAppWeek3 extends StatelessWidget {
  const MyAppWeek3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CST2335 • Week 3',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color(0xFFF9FAF3),
        textTheme: const TextTheme(
          headlineMedium:
          TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.8),
          titleMedium:
          TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2),
          bodyMedium: TextStyle(fontSize: 14.5, height: 1.35),
        ),
      ),
      home: const Week3LabPage(),
    );
  }
}

class Week3LabPage extends StatelessWidget {
  const Week3LabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Week 3 – Layouts')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // tighter layout
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== title + paragraph =====
            Column(
              children: [
                Text(
                  'BROWSE CATEGORIES',
                  style: t.textTheme.headlineMedium!.copyWith(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Not sure about exactly which recipe you're looking for? "
                      "Do a search, or dive into our most popular categories.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ===== BY MEAT =====
            SectionBlock(
              header: 'BY MEAT',
              rowChildren: const [
                CircleImageOverlay(path: 'images/beef.jpg', label: 'BEEF'),
                CircleImageOverlay(path: 'images/chicken.jpg', label: 'CHICKEN'),
                CircleImageOverlay(path: 'images/pork.jpg', label: 'PORK'),
                CircleImageOverlay(path: 'images/seafood.jpg', label: 'SEAFOOD'),
              ],
            ),

            const SizedBox(height: 28),

            // ===== BY COURSE =====
            SectionBlock(
              header: 'BY COURSE',
              rowChildren: const [
                CircleImageWithCaption(
                    path: 'images/main_dishes.jpg', caption: 'Main Dishes'),
                CircleImageWithCaption(
                    path: 'images/salad.jpg', caption: 'Salad Recipes'),
                CircleImageWithCaption(
                    path: 'images/side_dishes.jpg', caption: 'Side Dishes'),
                CircleImageWithCaption(
                    path: 'images/crockpot.jpg', caption: 'Crockpot'),
              ],
            ),

            const SizedBox(height: 28),

            // ===== BY DESSERT =====
            SectionBlock(
              header: 'BY DESSERT',
              rowChildren: const [
                CircleImageWithCaption(
                    path: 'images/icecream.jpg', caption: 'Ice Cream'),
                CircleImageWithCaption(
                    path: 'images/brownies.jpg', caption: 'Brownies'),
                CircleImageWithCaption(
                    path: 'images/pies.jpg', caption: 'Pies'),
                CircleImageWithCaption(
                    path: 'images/cookies.jpg', caption: 'Cookies'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// section with centered header + evenly spaced row
class SectionBlock extends StatelessWidget {
  final String header;
  final List<Widget> rowChildren;
  const SectionBlock({super.key, required this.header, required this.rowChildren});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 6),
        Text(header, style: t.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // lab requirement
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      ],
    );
  }
}

/// round image with overlay label (MEAT row)
class CircleImageOverlay extends StatelessWidget {
  final String path;
  final String label;
  const CircleImageOverlay(
      {super.key, required this.path, required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(path),
          radius: 40, // reduced size
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

/// round image with caption underneath (COURSE + DESSERT rows)
class CircleImageWithCaption extends StatelessWidget {
  final String path;
  final String caption;
  const CircleImageWithCaption(
      {super.key, required this.path, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(path),
          radius: 40, // reduced size
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          style: const TextStyle(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
