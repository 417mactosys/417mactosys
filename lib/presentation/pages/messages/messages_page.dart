import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/messages/messages_bloc.dart';
import '../../../domain/entities/message.dart';
import '../../../injection.dart';
import '../../components/empty_list_widget.dart';
import '../../components/message_list_shimmer.dart';
import '../../components/no_internet.dart';
import '../../routes/routes.dart';
import '../../utils/app_utils.dart';
import 'widgets/message_list_item.dart';
import 'package:http/http.dart';

import '../../../domain/entities/user.dart';

import 'dart:convert';
import '../../components/custom_circle_avatar.dart';
import '../../mrgreen/user_list.dart';
import '../../../infrastructure/core/pref_manager.dart';
import '../../../infrastructure/data/socket_io_manager.dart';

class MessagesPage extends StatefulWidget {
  static _MessagesPageState state;
  @override
  _MessagesPageState createState() {
    state = _MessagesPageState();
    return state;
  }
}

final List<int> visibleChat = [];

class _MessagesPageState extends State<MessagesPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  MessagesBloc _messagesBloc;

  Future<bool> refresh() {
    _messagesBloc.add(MessagesEvent.getMessages());
    return Future.value(true);
  }

  Future<bool> _update() {
    _messagesBloc.add(MessagesEvent.getMessages());
    return Future.value(true);
  }

  @override
  void initState() {
    _channelId = '${Prefs.getID()}';
    subscribe();
    super.initState();
  }

  bool _connected = false;
  SocketIoManager _socketIoManager;
  String _channelId;
  subscribe() {
    _socketIoManager = SocketIoManager(Routes.socketURL, {
      'channel': _channelId,
      'token': Prefs.getString(Prefs.ACCESS_TOKEN),
    })
      ..init().then((_) {
        print('connnnnn');
        _connected = !_connected;
        _socketIoManager.subscribe('receive_message', (jsonData) {
          print(jsonData);
          _update();
        });
        // _socketIoManager.subscribe('start_typing', (jsonData) {
        //   _bloc.add(MessagesEvent.isTyping(true));
        // });
        // _socketIoManager.subscribe('stop_typing', (jsonData) {
        //   _bloc.add(MessagesEvent.isTyping(false));
        // });
        // _socketIoManager.subscribe('disconnect', (jsonData) {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              BlocProvider(
                create: (context) => _messagesBloc = getIt<MessagesBloc>()
                  ..add(MessagesEvent.getMessages()),
                child: BlocConsumer<MessagesBloc, MessagesState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return state.messagesFailureOrSuccessOption.fold(
                      () => MessageListShimmer(),
                      (either) => either.fold(
                        (failure) => NoInternet(
                          onPressed: refresh,
                        ),
                        (success) => success.messages.isNotEmpty
                            ? _messagesWidget(success.messages)
                            : Center(
                                child: EmptyListWidget(
                                  icon: 'message-icon',
                                  //message: 'no_messages'.tr(),
                                  message:
                                      'No messages in your inbox, yet! Start chatting with people around.',
                                  title: 'No messages, yet.',
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),

              StreamBuilder(
                stream:
                    get('https://wilotv.live:3443/api/followings/${Prefs.getUser().id}/${Prefs.getUser().id}')
                        .asStream(),
                builder: (BuildContext c, AsyncSnapshot<Response> s) {
                  if (!s.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final List res = jsonDecode(s.data.body)['users'];
                  final list =
                      res.map((e) => User.fromJson(e)).toList(growable: true);
                  // list.forEach((element) {
                  //   if (visibleChat.contains(element.id)) {
                  //     list.remove(element);
                  //   }
                  // });
                  if (list.length == 0) {
                    return Container();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey.withOpacity(0.1),
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Suggestions',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (c, i) {
                          final user = list[i];
                          return InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.messagesDetails,
                              arguments: user,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color:
                                              Colors.grey.withOpacity(0.1)))),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomCircleAvatar(
                                    onTap: () {},
                                    radius: 21,
                                    url: AppUtils.getUserAvatar(
                                        user.id, user.avatar),
                                  ),
                                  SizedBox(
                                    height: 12,
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username,
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.fade,
                                        ),
                                        SizedBox(
                                          height: 6,
                                          width: 6,
                                        ),
                                        Text(
                                            '${user.firstName} ${user.lastName}')
                                      ],
                                    ),
                                  ),
                                  //Spacer(),
                                  // CustomButton(
                                  //     title: follow ? 'Follow' : 'Following',
                                  //     onPressed: () {
                                  //       HeyPApiService.create().followUser(widget.user.id);
                                  //       setState(() {
                                  //         follow = !follow;
                                  //         //user.follow = user.follow == 0 ? 1 : 0;
                                  //       });
                                  //     })
                                  //appUser ? Text("~ ${doc['name']}", style: TextStyle(color: Colors.grey),): Container()
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              //UsersList(Prefs.getUser().id, 'followers')
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _messagesWidget(List<Message> messages) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.1),
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (!visibleChat.contains(messages[index].receiver.id)) {
          visibleChat.add(messages[index].receiver.id);
        }
        return MessageListItem(
          message: messages[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.messagesDetails,
              arguments: messages[index].sender.id != AppUtils.getUserID()
                  ? messages[index].sender
                  : messages[index].receiver,
            );
          },
        );
      },
    );
  }
}
