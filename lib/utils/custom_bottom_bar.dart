import 'package:flutter/material.dart';
import 'package:vivatest/utils/text_styles.dart';

class CustomBottomBar extends StatefulWidget {
  final dynamic dashStrings;
  final dynamic dashColors;
  final bool dev;
  final dynamic screenSize;
  final int selectedIndex;
  final Function(int)? onTabChanged;

  const CustomBottomBar({
    Key? key,
    required this.dashStrings,
    required this.dashColors,
    required this.dev,
    required this.screenSize,
    required this.selectedIndex,
    this.onTabChanged,
  }) : super(key: key);

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late int selectedIndex;
  bool tab1 = true;
  bool tab2 = false;
  bool tab3 = false;
  bool tab4 = false;

  @override
  void initState() {
    super.initState();
    _setTabState(widget.selectedIndex);
  }

  void _updateTabStates(int index) {
    tab1 = index == 0;
    tab2 = index == 1;
    tab3 = index == 2;
    tab4 = index == 3;
  }

  void _setTabState(int index) {
    setState(() {
      selectedIndex = index;
      tab1 = index == 0;
      tab2 = index == 1;
      tab3 = index == 2;
      tab4 = index == 3;
    });
    widget.onTabChanged?.call(index);
  }

  void colorChange1() => _setTabState(0);
  void colorChange2() => _setTabState(1);
  void colorChange3() => _setTabState(2);
  void colorChange4() => _setTabState(3);

  @override
  Widget build(BuildContext context) {
    final dev = widget.dev;
    final Color bordercol = const Color(0xFF99E1D9);

    return Container(
      height: dev ? 80 : 92,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, left: 8, right: 8, top: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: bordercol),
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              width: double.infinity,
              height: dev ? 49 : 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: colorChange1,
                    child: Container(
                      height: dev ? 40 : 50,
                      padding: EdgeInsets.symmetric(horizontal: dev ? 8 : 12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.home,
                              color: tab1 ? Colors.black : Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Home',
                              style: TextStyles.monText(
                                color: tab1 ? Colors.black : Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: colorChange2,
                    child: Container(
                      height: dev ? 40 : 50,
                      padding: EdgeInsets.symmetric(horizontal: dev ? 8 : 12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              color: tab2 ? Colors.black : Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'History',
                              style: TextStyles.monText(
                                color: tab2 ? Colors.black : Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: colorChange3,
                    child: Container(
                      height: dev ? 40 : 50,
                      padding: EdgeInsets.symmetric(horizontal: dev ? 8 : 12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.upload,
                              color: tab3 ? Colors.black : Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Uploads',
                              style: TextStyles.monText(
                                color: tab3 ? Colors.black : Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: colorChange4,
                    child: Container(
                      height: dev ? 40 : 50,
                      padding: EdgeInsets.symmetric(horizontal: dev ? 8 : 12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person,
                              color: tab4 ? Colors.black : Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Profile',
                              style: TextStyles.monText(
                                color: tab4 ? Colors.black : Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
