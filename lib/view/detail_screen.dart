
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
 final String image , title, description, content, date, author, source;
  const DetailScreen({super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.content,
    required this.date,
    required this.author,
    required this.source,
    });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final format = DateFormat('MMMM, dd, yy');
  @override
  Widget build(BuildContext context) {
    DateTime dateTime =DateTime.parse(widget.date);
    final height = MediaQuery.sizeOf(context).height *1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SizedBox(
            height: height * .45,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),),
              child: CachedNetworkImage(
                  imageUrl: widget.image,
                placeholder: (context, url) => const Center(
                  child: SpinKitCircle(
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
                 errorWidget: (context, url, error) => const Icon(Icons.error, color:Colors.red,),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: height * .6,
            width: width * 1,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),),
            ),
            margin: EdgeInsets.only(top: height * .4,),
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
            child:ListView(
              
              children: [
                Text(widget.title, style: GoogleFonts.poppins(fontSize : height * 0.027, fontWeight: FontWeight.w700),),
                SizedBox(height: height * .018,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.source, style: GoogleFonts.poppins(fontSize : height * 0.018, fontWeight: FontWeight.w600, color: Colors.blue)),
                    Text(format.format(dateTime), style: GoogleFonts.poppins(fontSize : height * 0.018, fontWeight: FontWeight.w500))
                  ],
                ),
                SizedBox(height: height * .02,),
                
                Text(widget.description, style: GoogleFonts.poppins(fontSize : height * 0.02, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
