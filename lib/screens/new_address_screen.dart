import 'package:flutter/material.dart';

import '../router/router.dart';
import '../widgets/text_field_input.dart';

class NewAddressScreen extends StatelessWidget {
  NewAddressScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.newaddress),
      builder: (_) => NewAddressScreen(),
    );
  }

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

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
              'Receiver Name',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFieldInput(
              controller: fullnameController,
              hintText: 'Enter receiver name',
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: 16),
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
            Text(
              'Phone Number',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFieldInput(
              controller: phoneNumberController,
              hintText: 'Enter phone number',
              textInputType: TextInputType.phone,
            ),
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            primary: Colors.blueAccent.shade100,
          ),
          child: const Text('Save & Continue'),
        ),
      ),
    );
  }
}
