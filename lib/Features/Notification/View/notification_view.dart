import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../BLoC/notification_bloc.dart';
import '../BLoC/notification_state.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "الإشعارات",
              style: TextStyle(
              ),
            ),
            centerTitle: true,
            automaticallyImplyActions: false,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
          ),
          body: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoading) return Center(child: CircularProgressIndicator());
              if (state is NotificationLoaded) {
                return ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: state.notifications.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.notifications[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.pink.shade100,
                            child: Text("V", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 12),
                          // تفاصيل الإشعار
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(item.createDate, style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(item.body, style: TextStyle(color: Colors.grey.shade700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              if (state is NotificationError) return Center(child: Text(state.message));
              return Container();
            },
          ),
        ),
      ),
    );
  }
}