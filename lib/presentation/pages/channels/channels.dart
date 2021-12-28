import 'package:flutter/material.dart';
import 'channelItem.dart';
import '../../utils/constants.dart';
import 'createChannel.dart';
import '../../components/labeled_text_form_field.dart';
import '../../../infrastructure/api/api_service.dart';
import '../../../infrastructure/core/pref_manager.dart';

class ChannelsPage extends StatefulWidget {
  @override
  _ChannelsPageState createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: false,
        title: Text('Your Channels'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value(true);
        },
        child: StreamBuilder(
            stream:
                HeyPApiService.create().getChannels(Prefs.getUser().isChannel == 1 ? Prefs.getUser().owner_id : Prefs.getID()).asStream(),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.data.body.user.length == 0) {
                return Center(
                  child: Text('No Channels'),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.body.user.length,
                  itemBuilder: (b, i) {
                    return ChannelItem(snapshot.data.body.user[i]);
                  });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: kColorPrimary,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (b) => CreateChannel(null)));
        },
      ),
    );
  }
}
