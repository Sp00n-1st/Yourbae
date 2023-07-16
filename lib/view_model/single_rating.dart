import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/rating_model.dart';
import '../model/user_model.dart';

class SingleRating extends StatelessWidget {
  const SingleRating({Key? key, required this.ratingModel}) : super(key: key);
  final RatingModel ratingModel;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference<UserModel> users = firestore
        .collection('user')
        .doc(ratingModel.uidUser)
        .withConverter<UserModel>(
            fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()),
            toFirestore: (users, _) => users.toJson());
    String dateTime =
        DateFormat('dd/MM/yyyy').format(ratingModel.createdAt.toDate());

    return StreamBuilder(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: GoogleFonts.poppins(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: const CircularProgressIndicator(),
              ),
            );
          }
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 5.r),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  CircleAvatar(
                    maxRadius: 20.r,
                    backgroundImage: NetworkImage(snapshot.data!
                                .data()!
                                .imageProfile ==
                            null
                        ? 'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png'
                        : snapshot.data!.data()!.imageProfile!),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.data()!.name,
                        style: GoogleFonts.poppins(fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        dateTime,
                        style: GoogleFonts.poppins(fontSize: 10.sp),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  )
                ]),
                SizedBox(
                  height: 5.h,
                ),
                RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: 20.r,
                  initialRating: ratingModel.star,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'Size - ${ratingModel.size}',
                  style:
                      GoogleFonts.poppins(color: Colors.grey, fontSize: 12.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  ratingModel.comment,
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                )
              ],
            ),
          );
        });
  }
}
