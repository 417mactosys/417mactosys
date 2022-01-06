import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wilotv/presentation/pages/explore/explore_page.dart';
import 'package:wilotv/presentation/pages/home/widgets/loader.dart';
import 'package:wilotv/presentation/pages/home/widgets/messages_widget.dart';
import 'package:wilotv/presentation/pages/home/widgets/notification_widget.dart';
import 'package:wilotv/presentation/pages/messages/messages_page.dart';
import 'package:wilotv/presentation/pages/settings/settings_page.dart';

import './home_page.dart';
import '../../../infrastructure/core/pref_manager.dart';
import '../../components/custom_navigation_bar.dart';
import '../../mrgreen/app_drawer.dart';
import '../../mrgreen/pixalive_videoplayer.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import 'delegates/search_delegate.dart';
import 'home_page.dart';
import 'widgets/add_post_button_widget.dart';
import 'widgets/nav_bar_item_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController _controller;

  final _pages = [
    HomePage(),
    ExplorePage(),
    Container(),
    MessagesPage(),
    SettingsPage(),
  ];

  final _titles = [
    '',
    'explore'.tr(),
    '',
    'Messages'.tr(),
    'settings'.tr(),
  ];

  @override
  initState() {
    super.initState();
    _controller = PageController(
      initialPage: _selectedIndex,
    );
    // firebaseAuth();
  }

  // firebaseAuth() async {
  //
  //   UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  // }
  _selectPage(int index) {
    //MOVED = true;
    PixaliveVideoPlayer.pauseAll();
    setState(() {
      if (_controller.hasClients) _controller.jumpToPage(index);
      _selectedIndex = index;
    });
  }

  Widget _logoWidget() {
    return Image.asset(
      'assets/images/text_logo.png',
      height: 36,
    );
  }

  Widget _messagesWidget() {
    return NotificationWidget();
  }

  Widget _searchWidget() {
    return Transform(
      transform: Matrix4.translationValues(_selectedIndex == 0 ? 8 : 0, 0, 0),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/images/search.svg',
          width: 24,
          color: Prefs.isDark()
              ? Colors.white.withOpacity(0.87)
              : Color(0xff505050),
        ),
        onPressed: () {
          PixaliveVideoPlayer.pauseAll();
          showSearch(
            context: context,
            delegate: PostSearch(),
          );
        },
      ),
    );
  }

  var key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Prefs.isDark() ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Color(0xffedeeee),

        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/menu.svg',
            width: 24,
            color: Prefs.isDark()
                ? Colors.white.withOpacity(0.87)
                : Color(0xff505050),
          ),
          onPressed: () {
            PixaliveVideoPlayer.pauseAll();
            key.currentState.openDrawer();
          },
        ),

        // leading: Padding(
        //   padding: const EdgeInsets.all(8),
        //   child: CustomCircleAvatar(
        //     radius: 12,
        //     url: AppUtils.getAvatar(),
        //     onTap: (){
        //       PixaliveVideoPlayer.pauseAll();
        //       Navigator.pushNamed(
        //       context,
        //       Routes.profile,
        //     );
        //       //key.currentState.openDrawer();
        //       },
        //   ),
        // ),
        title:
            _selectedIndex == 0 ? _logoWidget() : Text(_titles[_selectedIndex]),
        centerTitle: true,
        actions: [
          _searchWidget(),
          if (_selectedIndex == 0) _messagesWidget(),
        ],
      ),
      drawer: Drawer(
        child: PixaliveAppDrawer(),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _pages,
          ),
          Align(alignment: Alignment.topCenter, child: UploadProgress()),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: AddPostButtonWidget(
          onPressed: () async {
            PixaliveVideoPlayer.pauseAll();
            final result =
                await Navigator.of(context).pushNamed(Routes.addPost);
            if (result != null) {}
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomNavigationBar(
        backgroundColor: Prefs.isDark() ? Color(0xff121212) : Colors.white,
        strokeColor: kColorPink,
        items: [
          NavBarItemWidget(
            onTap: () {
              if (_selectedIndex == 0) {
                HomePage.state.refresh();
              }
              _selectPage(0);
            },
            image: 'home',
            isSelected: _selectedIndex == 0,
          ),
          NavBarItemWidget(
            onTap: () {
              _selectPage(1);
            },
            image: 'discover',
            isSelected: _selectedIndex == 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: NavBarItemWidget(
              onTap: () {},
              image: '',
              isSelected: false,
            ),
          ),
          MessagesWidget(
            onTap: () {
              _selectPage(3);
            },
            //image: 'chat',
            isSelected: _selectedIndex == 3,
          ),
          NavBarItemWidget(
            onTap: () {
              _selectPage(4);
            },
            image: 'settings',
            isSelected: _selectedIndex == 4,
          ),
//          CustomCircleAvatar(
//            radius: 18,
//            url: AppUtils.getAvatar(),
//            onTap: () => Navigator.pushNamed(
//              context,
//              Routes.profile,
//            ),
//          ),
        ],
        currentIndex: _selectedIndex,
        elevation: 0,
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
      ),
    );
  }
}
