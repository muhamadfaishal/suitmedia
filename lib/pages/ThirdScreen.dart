import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia/model/user_model.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            Provider.of<UserModel>(context, listen: false).hasMore &&
            !Provider.of<UserModel>(context, listen: false).isLoading) {
          Provider.of<UserModel>(context, listen: false).fetchUsers();
        }
      });

    Future.delayed(Duration.zero, () {
      Provider.of<UserModel>(context, listen: false).fetchUsers();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Third Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await userModel.fetchUsers(isRefresh: true);
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: userModel.users.length + (userModel.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < userModel.users.length) {
                  final user = userModel.users[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24.5,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                      subtitle: Text(
                        user.email,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      onTap: () {
                        Provider.of<UserModel>(context, listen: false)
                            .setSelectedUsername(
                                '${user.firstName} ${user.lastName}');
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                } else {
                  if (userModel.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text('No more users'));
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
