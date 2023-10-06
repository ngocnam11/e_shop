import 'package:e_shop/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../router/app_router.dart';
import 'package:e_shop/data/models/notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRouter.notification),
      builder: (_) => const NotificationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12),
            StreamBuilder<List<NotificationModel>>(
                stream: FireStoreServices().getCurrentUserNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return const Text('Something went wrong');
                  }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.celebration_outlined),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data![index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    snapshot.data![index].body,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_horiz),
                                ),
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    DateFormat('dd-MM-yy hh:mm').format(snapshot
                                        .data![index].createdAt
                                        .toDate()),
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
