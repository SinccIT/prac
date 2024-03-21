import 'package:syncc_it/group/group_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GroupService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 800),
  );

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SynccIT"),
      ),
      body: _tabBar(),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(text: "공유 목록"),
        Tab(text: "연락처 목록"),
      ],
    );
  }
}

class Group {
  String job; // 할 일
  bool isDone; // 완료 여부

  Group(this.job, this.isDone); // 생성자
}

//// 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupService>(
      builder: (context, groupService, child) {
        // toDoService로 부터 toDoList 가져오기
        List<Group> groupList = groupService.groupList;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text("group 리스트"),
          ),
          body: groupList.isEmpty
              ? Center(
                  child: Text("Group 목록을 작성해주세요"),
                )
              : ListView.builder(
                  itemCount: groupList.length,
                  itemBuilder: (context, index) {
                    Group group = groupList[index];
                    return ListTile(
                      title: Text(
                        group.job,
                        style: TextStyle(
                          fontSize: 20,
                          color: group.isDone ? Colors.grey : Colors.black,
                          decoration: group.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          CupertinoIcons.delete,
                        ),
                        onPressed: () {
                          //삭제 버튼이 눌렀을 때 작동
                          groupService.deleteGroup(index);
                        },
                      ),
                      onTap: () {
                        //아이템 클릭시
                        group.isDone = !group.isDone;
                        groupService.updateGroup(group, index);
                      },
                    );
                  }),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // + 버튼 클릭시 ToDo 생성 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreatePage()),
              );
            },
          ),
        );
      },
    );
  }
}

/// Group 생성 페이지
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // TextField의 값을 가져올 때 사용
  TextEditingController textController = TextEditingController();

  // 경고 메세지
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("group 목록 작성"),
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 텍스트 입력창
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Group 목록을 작성해주세요",
                errorText: error,
              ),
            ),
            SizedBox(height: 20),
            // 추가하기 버튼
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                child: Text(
                  "추가하기",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  // 추가하기 버튼 클릭시
                  String job = textController.text;
                  if (job.isEmpty) {
                    setState(() {
                      // 내용이 없는 경우 에러 메세지
                      error = "내용을 입력해주세요.";
                    });
                  } else {
                    setState(() {
                      // 내용이 있는 경우 에러 메세지 숨김
                      error = null;
                    });
                    GroupService groupService = context.read<GroupService>();
                    // ToDoService에 있는 createToDo 메스더 사용
                    groupService.createGroup(job);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
