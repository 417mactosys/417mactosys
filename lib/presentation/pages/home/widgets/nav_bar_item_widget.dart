import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../infrastructure/core/pref_manager.dart';

class NavBarItemWidget extends StatelessWidget {
  final Function onTap;
  final String image;
  final bool isSelected;

  const NavBarItemWidget({
    Key key,
    @required this.onTap,
    @required this.image,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: true);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        child: Center(
          child: (isDark && !isSelected)
              ? image.isEmpty
                  ? Container()
                  : SvgPicture.asset(
                      'assets/images/$image.svg',
                      height: image == 'chat' ? 30 : 25,
                      color: Color(0xffc3c3c3),
                    )
              : (!isDark && !isSelected)
                  ? image.isEmpty
                      ? Container()
                      : SvgPicture.asset(
                          'assets/images/$image.svg',
                          height: image == 'chat' ? 30 : 25,
                          color: Color(0xffc3c3c3),
                        )
                  : image.isEmpty
                      ? Container()
                      : ShaderMask(
            shaderCallback: (r){
              return LinearGradient(
                  colors: [Colors.pinkAccent, Colors.orange], begin: Alignment.bottomRight, //radius: 0.1,
                  end: Alignment.topLeft
              ).createShader(r);
            },
                          child: SvgPicture.asset(
                            'assets/images/${image}.svg',
                            color: Colors.white,
                            height: image == 'chat' ? 30 : 25,
                          ),
                        ),
        ),
      ),
    );
  }
}
