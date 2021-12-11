import 'package:flutter/material.dart';
import 'package:social_network_front/ui/pages/chatroom/chatroom_page.dart';
import 'package:social_network_front/ui/widgets/flow_menu_component.dart';
import 'package:social_network_front/ui/pages/profile/profile_page.dart';
import 'package:social_network_front/ui/pages/search/search_page.dart';

import '../../../try_images.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late AnimationController menuAnimation;

  late List<Map<String, dynamic>> menuItems;
  IconData lastIcon = Icons.new_releases;
  IconData lastTapped = Icons.person;
  String title = 'Acceuil';
  Widget actualPage = ProfilePage();

  void buildMenu() {
    menuItems = [
      {
        'icon': Icons.person,
        'action': () => _updateMenu(icon: Icons.person, page: ProfilePage(), newTitle: 'profile'),

      },
      {
        'icon': Icons.search,
        'action': () => _updateMenu(icon: Icons.search, page: Search(), newTitle: 'recherche utilisateur')
      },
      {
        'icon': Icons.new_releases,
        'action': () =>
            _updateMenu(icon: Icons.new_releases, page: ChatRoom(), newTitle: 'messagerie'),
      },
      {
        'icon': Icons.add_a_photo,
        'action': () =>
            _updateMenu(icon: Icons.add_a_photo, page: LoadFirbaseStorageImage(), newTitle: 'load_image')
      }


    ];
  }

  void _updateMenu({required IconData icon, required page, required String newTitle}) {
    if (menuAnimation.status != AnimationStatus.completed) {
      menuAnimation.forward();
      setState(() {
        menuItems.last['icon'] = lastIcon;
      });
    } else {
      menuAnimation.reverse();
      setState(() {
        if (actualPage != page) {
          actualPage = page;
          // title = page.title;
          title = newTitle;
        }
        lastTapped = icon;
        menuItems.last['icon'] = icon;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    buildMenu();
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: ListView(
            children: const [
              DrawerHeader(
                child: Text('Settings'),
              ),
              ListTile(
                title: Text('Item 1'),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Flow(
          delegate:
              FlowMenuDelegate(menuAnimation: menuAnimation, rightToLeft: true),
          children: menuItems.map<Widget>((item) {
            return flowMenuItem(
                icon: item['icon'], action: item['action'], context: context);
          }).toList(),
        ),
        body: Center(child: actualPage));
  }
}
