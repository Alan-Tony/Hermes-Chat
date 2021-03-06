import 'package:chat_app_project/global_variables.dart';
import 'package:chat_app_project/models/dm_model.dart';
import 'package:chat_app_project/models/message_model.dart';
import 'package:chat_app_project/models/request_for_list_of_messages_DM.dart';
import 'package:chat_app_project/pages/chat_window.dart';
import 'package:flutter/material.dart';

class chats_received_sent extends StatelessWidget {
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
            itemCount: list_of_DMs.length,
            itemBuilder: (BuildContext context, int k) {
              return GestureDetector(
                onTap: () async {
                    await request_for_list_of_messages_for_DM(k);
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Chat_Window(iter: k,full_name: list_of_DMs[k].friend.full_name)));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    right: 20.0,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 7.5, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: true ? Color(0xFFFFEFEE) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 35.0,
                            backgroundImage:
                                AssetImage('assets/images/group.jpg.png'),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Text(
                                  list_of_DMs[k].friend.full_name,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  list_of_DMs[k].messages.length!=0 ?
                                  (list_of_DMs[k].messages[0].sender_username==username_of_current_user ?
                                  "you: " + list_of_DMs[k].messages[0].text_message : list_of_DMs[k].messages[0].sender_username + ": " + list_of_DMs[k].messages[0].text_message) : "no convo started",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w800,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            list_of_DMs[k].messages[0].time_stamp.split(" ")[1].split(".")[0],
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          true
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
