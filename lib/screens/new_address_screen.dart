import 'package:flutter/material.dart';

import '../config/utils.dart';
import '../router/router.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../widgets/text_field_input.dart';
import 'delivery_address_screen.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.newAddress),
      builder: (_) => const NewAddressScreen(),
    );
  }

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  void addDeliveryAddress() async {
    String res = await FireStoreServices().addDeliveryAddress(
      uid: AuthServices().currentUser.uid,
      address: addressController.text,
      city: cityController.text,
      country: countryController.text,
    );

    if (!mounted) return;

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFieldInput(
              controller: addressController,
              hintText: 'Enter address',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Text(
              'City',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFieldInput(
              controller: cityController,
              hintText: 'Enter city',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Text(
              'Country',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFieldInput(
              controller: countryController,
              hintText: 'Enter country',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                Text(
                  'Save my shipping infomation',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: addDeliveryAddress,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            backgroundColor: Colors.blueAccent.shade100,
          ),
          child: const Text('Save & Continue'),
        ),
      ),
    );
  }
}
