import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Model/news_category_model.dart';
import 'package:news_app/Model/news_headlines_model.dart';
import 'package:news_app/view/category_screen.dart';
import 'package:news_app/view/detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {bbcNews, aryNews, independent, reuters, cnn, aljazeera}

class _HomeScreenState extends State<HomeScreen> {
  FilterList? selectedMenu;
  final NewsViewModel _newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM, dd, yyyy');
  String name="bbc-news";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const CategoryScreen()));
            },
            icon: Image.asset(
              'images/category_icon.png',
              height: 25,
              width: 30,
            )),
        title: Text(
          'News',
          style:
              GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
              onSelected: (FilterList item){
                if(FilterList.bbcNews==item){
                  name = 'bbc-news';
                }
                if(FilterList.aryNews==item){
                  name = 'ary-news';
                }
                if(FilterList.cnn==item){
                  name = 'cnn';
                }if(FilterList.aljazeera==item){
                  name = 'al-jazeera-english'
                      '';
                }
              setState(() {
                selectedMenu =item;
              });
              },
              itemBuilder: (BuildContext context)=> <PopupMenuEntry<FilterList>>[
                const PopupMenuItem(
                  value:FilterList.bbcNews ,
                    child: Text('BBC'),
                ),
                const PopupMenuItem(
                  value:FilterList.aryNews ,
                    child: Text('ARY'),
                ),
                const PopupMenuItem(
                  value:FilterList.cnn ,
                    child: Text('CNN'),
                ),
                const PopupMenuItem(
                  value:FilterList.aljazeera ,
                    child: Text('ALJAZEERA'),
                ),
              ])
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
              height: height * .55,
              width: width,
              child: FutureBuilder<TopHeadlinesModel>(
                future: _newsViewModel.fetchNewsHeadlines(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 40,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                        DateTime dateTime =DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                              image:snapshot.data!.articles![index].urlToImage.toString(),
                              title: snapshot.data!.articles![index].title.toString(),
                              description: snapshot.data!.articles![index].description.toString(),
                              content: snapshot.data!.articles![index].content.toString(),
                              date: snapshot.data!.articles![index].publishedAt.toString(),
                              author: snapshot.data!.articles![index].author.toString(),
                              source: snapshot.data!.articles![index].source!.name.toString()),));
                          // print(snapshot.data!.articles![index].author.toString());
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: height*0.6,
                                width: width*.9,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: width *.04),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      placeholder: (context, url) => Container(
                                        child: spinKit2,
                                      ),
                                      errorWidget: (context, url, error) => const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 20,
                                child: Card(
                                  // color: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    height: height*.22,
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width*0.7,
                                          child: Text(snapshot.data!.articles![index].title.toString(),
                                          style: GoogleFonts.poppins(fontSize:17, fontWeight:FontWeight.w700),
                                          maxLines: 3,),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: width*0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString()),
                                              Text(format.format(dateTime))
                                            ],
                                          ),
                                        )


                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  }
                },
              )),

          const SizedBox(
            height: 20,
          ),

          FutureBuilder<NewsCategoryModel>(
              future: _newsViewModel.fetchNewsCategory('General'),
              builder: (BuildContext context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50,
                    ),
                  );
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                      physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                      itemBuilder: (context, index){
                      DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                                image: snapshot.data!.articles![index].urlToImage.toString(),
                                title: snapshot.data!.articles![index].title.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                date: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString()),));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                      height : height * .18,
                                      width: width * .3,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child: SpinKitCircle(
                                        size: 40,
                                        color: Colors.amber,
                                      ),),
                                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red,),
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString()),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: SizedBox(
                                    height: height * .18,
                                    child: Column(
                                      children: [
                                        Text(snapshot.data!.articles![index].title.toString(), style: GoogleFonts.poppins(fontSize : 14, fontWeight:FontWeight.w700),
                                        maxLines: 3,),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data!.articles![index].source!.name.toString(), style: GoogleFonts.poppins(fontSize: 10, fontWeight:FontWeight.w600),),
                                            Text(format.format(datetime), style: GoogleFonts.poppins(fontSize : 10, fontWeight: FontWeight.w500),),

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        );
                      });
                }
              })
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  size: 40,
  color: Colors.amber,
);
