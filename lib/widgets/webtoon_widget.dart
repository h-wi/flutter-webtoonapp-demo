import 'package:flutter/material.dart';
import 'package:webtoon/screen/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 대부분의 동작(event)을 감지하는 위젯
      onTap: () {
        // 이 위젯을 Tap하면 다른 screen으로 보내주기
        Navigator.push(
          context,
          MaterialPageRoute(
            // 보내주는 위젯 : Navigator.push, 다른 위젯을 불러온 건데 페이지가 바뀐 것처럼 보인다. by 애니메이션 효과!
            // context와 Route(MaterialPageRoute) 필요
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
          ),
        );
      },
      child: Column(
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
            child: Image.network(thumb),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
