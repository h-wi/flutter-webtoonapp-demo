import 'package:flutter/material.dart';
import 'package:webtoon/widgets/episodes_widget.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        isLiked = true;
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(
        widget.id); // home_screen과 다른 점, 거기 메소드는 argument를 요구하지 않는다.
    episodes = ApiService.getLastestEpisodesById(
        widget.id); // 여기선 id가 필요하므로 argument가 생기는데, InitState로 Instance 생성
    // 따라서 DetailScreen class는 StatefulWidget로 되어야 한다.
  }

  // onHeartTap() async {
  //   final likedToons = prefs.getStringList('likedToons');
  //   if (likedToons != null) {
  //     if (isLiked) {
  //       likedToons.remove(widget.id);
  //     } else {
  //       likedToons.add(widget.id);
  //     }
  //     await prefs.setStringList('likedToons', likedToons);
  //     setState(() {
  //       isLiked = !isLiked;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 4,
        title: Text(
          widget.title, // Stless일 경우 같은 클래스였어서 그냥 title
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        // actions: [
        //   IconButton(
        //     // shared_preferences를 이용해서 사용자 핸드폰에 favorite 데이터 저장.
        //     onPressed: onHeartTap,
        //     icon: Icon(
        //         isLiked ? Icons.favorite : Icons.favorite_outline_outlined),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 50,
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          offset: const Offset(10, 10),
                          color: Colors.black.withOpacity(0.5),
                        )
                      ]),
                  width: 200,
                  child: Image.network(widget.thumb),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder(
              // 미래의 위젯과 데이터를 Build = Future
              future: webtoon,
              builder: (context, snapshot) {
                // {} 를 일종의 메소드로 생각, return 값 필요, ()은 argument
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.about,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${snapshot.data!.genre} / ${snapshot.data!.age}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );
                }
                return const Text('...');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: episodes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    // 리스트의 크기가 10개로 정해져있고, 그 크기도 크지 않으므로 Listview대신 Column 사용
                    children: [
                      for (var episode in snapshot.data!)
                        Episode(
                          episode: episode,
                          webtoon_id: widget.id,
                        ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ]),
        ),
      ),
    ); // 새로운 screen에서는 내비게이션 바도 바뀌기 때문에 Appbar등 완전 처음부터 bulid
  }
}
