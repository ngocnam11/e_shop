import 'package:e_shop/models/delivery_address.dart';
import 'package:flutter/material.dart';

import '../config/utils.dart';
import '../router/router.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../widgets/text_field_input.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({
    Key? key,
    required this.deliveryAddress,
  }) : super(key: key);

  final DeliveryAddress deliveryAddress;

  static MaterialPageRoute route({required DeliveryAddress address}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.editAddress),
      builder: (_) => EditAddressScreen(
        deliveryAddress: address,
      ),
    );
  }

  @override
  State<EditAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<EditAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    _addressController.text = widget.deliveryAddress.address;
    _cityController.text = widget.deliveryAddress.city;
    _countryController.text = widget.deliveryAddress.country;
    super.initState();
  }

  void updateDeliveryAddress() async {
    String res = await FireStoreServices().updateShippingAddress(
      uid: AuthServices().currentUser.uid,
      address: _addressController.text,
      city: _cityController.text,
      country: _countryController.text,
    );

    if (!mounted) return;

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
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
              controller: _addressController,
              hintText: 'Enter address',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Text(
              'City',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFieldInput(
              controller: _cityController,
              hintText: 'Enter city',
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Text(
              'Country',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFieldInput(
              controller: _countryController,
              hintText: 'Enter country',
              textInputType: TextInputType.text,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: updateDeliveryAddress,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blueAccent.shade100,
          ),
          child: const Text('Save'),
        ),
      ),
    );
  }
}
