import 'package:flutter/material.dart';
import '../../../../infrastructure/core/pref_manager.dart';

class SearchUser extends StatefulWidget {
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final searchBar = Container(
    child: SizedBox(
      height: 36,
      child: TextFormField(
        autofocus: true,
        onChanged: (s) {
          // setState(() {
          //   keyword = s;
          // });
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: Prefs.isDark() ? Colors.white12 : Colors.black12,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            hintText: 'Search',
            hintStyle: TextStyle(
                color: Prefs.isDark() ? Colors.white24 : Colors.black26)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0.0,
        shadowColor: Color(0xffedeeee),
        title: searchBar,
        actions: [
          // IconButton(
          //   icon: Icon(showSearch ? Icons.close_rounded : CupertinoIcons.search, color: (Prefs.isDark() ? Colors.white : Colors.black ).withOpacity(0.8),),
          //   onPressed: (){
          //     setState(() {
          //       showSearch = !showSearch;
          //     });
          //   },
          // )
        ],
      ),
    );
  }
}
