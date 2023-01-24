import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/services/auth_service.dart';
import 'package:webtoon/widgets/auth_widget.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        title: const Text(
          'Today\'s toons',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: FutureBuilder(
        // future 값을 기다려주는 widget, await & setState 필요없음.
        future: webtoons,
        builder: (context, snapshot) {
          // snapshot : Future 데이터의 상태(로딩중,완료,에러..) & 받아온 데이터
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 150,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Consumer<ApplicationState>(
                            builder: ((context, appState, _) => AuthFunc(
                                loggedIn: appState.loggedIn,
                                signOut: () {
                                  FirebaseAuth.instance.signOut();
                                })),
                          ),
                          StreamBuilder(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder:
                                (BuildContext _, AsyncSnapshot<User?> user) {
                              if (!user.hasData) {
                                return const googleLogin();
                              }
                              return const SizedBox(
                                width: 1,
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ), //builder : 위젯(UI)를 리턴하는 함수, future : 기다릴 Future 값(data)
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      // ListView = 여러 항목을 나열할 때 좋은 Widget, but 메모리 많이 쓴다
      scrollDirection: Axis
          .horizontal, // ListView.builder = 메모리 최적화됨, 인덱스로 지정된 항목말고는 버리기 때문에
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          // 여기에 쓰인 return은 itemBuilder의 함수에 대한 값
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
