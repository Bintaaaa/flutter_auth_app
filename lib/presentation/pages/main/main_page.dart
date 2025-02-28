import 'package:flutter/material.dart';
import 'package:flutter_auth_app/core/core.dart';
import 'package:flutter_auth_app/data/data.dart';
import 'package:flutter_auth_app/presentation/presentation.dart';
import 'package:flutter_auth_app/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///*********************************************
/// Created by ukietux on 25/08/20 with ♥
/// (>’_’)> email : hey.mudassir@gmail.com
/// github : https://www.github.com/Lzyct <(’_’<)
///*********************************************
/// © 2020 | All Right Reserved
class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<DataHelper> _dataMenus;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dataMenus = [
      DataHelper(
        title: Strings.of(context)!.dashboard,
        isSelected: true,
      ),
      DataHelper(
        title: Strings.of(context)!.settings,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log.d("onBackPress");
        if (_dataMenus[_currentIndex].title == Strings.of(context)!.dashboard) {
          log.d("true");

          return true;
        } else {
          log.d("false");
          if (_scaffoldKey.currentState!.isEndDrawerOpen) {
            //hide navigation drawer
            _scaffoldKey.currentState!.openDrawer();
          } else {
            context.read<NavDrawerCubit>().openDrawer(Navigation.dashboardPage);

            for (final menu in _dataMenus) {
              setState(() {
                menu.isSelected = menu.title == Strings.of(context)!.dashboard;
              });
            }
          }

          return false;
        }
      },
      child: Parent(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar(),
        drawer: SizedBox(
          width: context.widthInPercent(80),
          child: MenuDrawer(
            dataMenu: _dataMenus,
            currentIndex: (int index) {
              /// Update title based on selected drawer
              setState(() {
                _currentIndex = index;
              });

              /// hide navigation drawer
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ),
        child: BlocBuilder<NavDrawerCubit, Widget>(
          builder: (context, navigationState) {
            return navigationState;
          },
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          _dataMenus[_currentIndex].title ?? "-",
        ),
        leading: IconButton(
          icon: Icon(
            Icons.sort,
            size: Dimens.space24,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: const [
          /// Notification on Dashboard
          ButtonNotification(),
        ],
      ),
    );
  }
}
