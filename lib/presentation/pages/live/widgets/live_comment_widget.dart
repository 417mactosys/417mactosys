import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wilotv/application/comment/comment_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wilotv/presentation/utils/constants.dart';

class LiveCommentWidget extends StatefulWidget {
  final Function onPressed;

  const LiveCommentWidget({Key key, @required this.onPressed,}) : super(key: key);

  @override
  _LiveCommentWidgetState createState() => _LiveCommentWidgetState();
}

class _LiveCommentWidgetState extends State<LiveCommentWidget> {

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                hintText:  'fill_the_field'.tr(),

              ),
              minLines: 1,
              maxLines: 5,
              onChanged: (value) {
                return context.bloc<CommentBloc>()
                    .add(CommentEvent.commentChanged(value));
              },
              validator: (_) =>
                  context.bloc<CommentBloc>().state.comment.value.fold(
                        (f) => f.maybeMap(
                      empty: (_) => 'fill_the_field'.tr(),
                      orElse: () => null,
                    ),
                        (_) => null,
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                _controller.clear();
                widget.onPressed();
                FocusScope.of(context).requestFocus(FocusNode());
                context.bloc<CommentBloc>().add(CommentEvent.commentChanged(''));
              },
              child: Icon(
                Icons.send,
                color: kColorPrimary,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
          ),
        ],
      ),
    );
  }
}
