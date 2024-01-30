import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentapi/provider/user_provider.dart';
import 'package:studentapi/ui/edit_page.dart';
import 'package:studentapi/ui/insert_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Consumer<UserProvider>(builder: (context, value, child) {
        if (value.isLoding) {
          return const CircularProgressIndicator();
        }
        final posts = value.posts;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            var user = posts[index];
            return Card(
                child: ListTile(
              onTap: () async {
                controller.editstudentNameController.text =
                    user.studentName.toString();
                controller.editstudentClassController.text =
                    user.studentClass.toString();
                controller.editteacherNameController.text =
                    user.teacherName.toString();
                controller.editparentNameController.text =
                    user.parentName.toString();
                controller.editparentPhController.text =
                    user.parentPh.toString();
                controller.editrollNoController.text = user.rollNo.toString();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditPage(user: user)));
              },
              leading: Text(posts[index].id.toString()),
              tileColor: Colors.blue.withOpacity(0.2),
              title: Text(
                posts[index].studentName.toString(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                children: [
                  Text(posts[index].studentClass.toString()),
                  Text(posts[index].teacherName.toString()),
                  // Text(posts[index].status.toString()),
                ],
              ),
              trailing: GestureDetector(
                  onTap: () async {
                    controller.deleteData(user.id.toString(), context);

                    print('clicked');
                  },
                  child: const Icon(Icons.delete, color: Colors.red)),
            ));
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const InsertPage()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
