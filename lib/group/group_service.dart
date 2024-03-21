import 'package:flutter/cupertino.dart';

import 'main.dart';

class GroupService extends ChangeNotifier {
  List<Group> groupList = [
    //더미네이터
    Group('공부하기', false),
  ];

  // 추가
  void createGroup(String job) {
    groupList.add(Group(job, false));
    // 갱신 : Consumer로 등록된 곳의 buyilder만 새로 갱신해서 화면을 다시 그린다.
    notifyListeners();
  }

  // 수정
  void updateGroup(Group group, int index) {
    groupList[index] = group;
    notifyListeners();
  }

  //삭제
  void deleteGroup(int index) {
    groupList.removeAt(index);
    notifyListeners();
  }
}
