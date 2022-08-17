import 'package:flutter/material.dart';

import '../widgets/section_title.dart';
import '../widgets/text_field_input.dart';
// import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eShop'),
      ),
     
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFieldInput(
              controller: searchController,
              hintText: 'Search Products',
              textInputType: TextInputType.text,
              prefixIcon: const Icon(Icons.search),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              width: 100,
              color: Colors.blue,
              child: const Text('Carousel slider'),
            ),
            const SizedBox(
              height: 10,
            ),
            SectionTitle(
              title: 'Recommended',
              press: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Text('Bottom Nav Bar'),
      )
    );
  }
}
