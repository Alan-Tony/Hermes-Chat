import 'package:chat_app_project/models/channels.dart';
import 'package:chat_app_project/models/message_model.dart';
import 'package:chat_app_project/pages/chat_window.dart';
import 'package:flutter/material.dart';

class list_of_channels extends StatelessWidget {
  final List<CHANNELS> channels;
  list_of_channels({required this.channels});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 250.0, //just used to test
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.0),
            topRight: Radius.circular(28.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.0),
            topRight: Radius.circular(28.0),
          ),
          child: ListView.builder(
            itemCount: channels.length,
            itemBuilder: (BuildContext context, int k) {
              return GestureDetector(
                onTap: () =>
                     Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (_) => Chat_Window(person1: chats[k].sender))),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    right: 20.0,
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 7.5, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFEFEE),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35.0,
                            backgroundImage:
                            AssetImage('assets/images/greg.jpg.png'),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Text(
                                  channels[k].name,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Channel Text",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "time",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          chats[k].unread
                              ? Container(
                            width: 40.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                              : Text(''),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
