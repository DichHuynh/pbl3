import 'package:flutter/cupertino.dart';

//Pages that Icons lead to
// Weather Page
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBlue,
        middle: const Text(
          'Dự báo thời tiết',
          style: TextStyle(color: CupertinoColors.black),
        ),

        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.black),
          onPressed: () => Navigator.pop(context),
        ),

        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add, color: CupertinoColors.black),
          onPressed: () {} //
        ),
      ),
      child: const Center(
        child: Text(
          'Tạm thời để đây đã code cái này sau',
          style: TextStyle(fontSize: 18, color: CupertinoColors.black)
        )
      ),
    );
  }
}

//Dong gop y kien
class OpinionPage extends StatelessWidget {
  const OpinionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.activeBlue,
        middle: const Text(
          'Đóng góp ý kiến',
          style: TextStyle(color: CupertinoColors.black),
        ),

        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.black),
          onPressed: () => Navigator.pop(context),
        ),

        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add, color: CupertinoColors.black),
          onPressed: () {} //
        ),
      ),
      child: const Center(
        child: Text(
          'Tạm thời để đây đã code cái này sau',
          style: TextStyle(fontSize: 18, color: CupertinoColors.black)
        )
      ),
    );
  }
}

//Service Page
//Dong gop y kien
class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.activeBlue,
        middle: const Text(
          'Dịch vụ công',
          style: TextStyle(color: CupertinoColors.black),
        ),

        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.black),
          onPressed: () => Navigator.pop(context),
        ),

        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add, color: CupertinoColors.black),
          onPressed: () {} //
        ),
      ),
      child: const Center(
        child: Text(
          'Tạm thời để đây đã code cái này sau',
          style: TextStyle(fontSize: 18, color: CupertinoColors.black)
        )
      ),
    );
  }
}

////Chua biet nx - page :)
class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.activeBlue,
        middle: const Text(
          'Khác ...',
          style: TextStyle(color: CupertinoColors.black),
        ),

        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.black),
          onPressed: () => Navigator.pop(context),
        ),

        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add, color: CupertinoColors.black),
          onPressed: () {} //
        ),
      ),
      child: const Center(
        child: Text(
          'Tạm thời để đây đã code cái này sau',
          style: TextStyle(fontSize: 18, color: CupertinoColors.black)
        )
      ),
    );
  }
}