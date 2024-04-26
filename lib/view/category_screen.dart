import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/news_category_model.dart';
import 'package:news_app/Repository/news_repository.dart';
import 'package:news_app/view/detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  NewsRepository newsRepository = NewsRepository();

  List<String> categoriesList = [
    'General',
    'Sports',
    'Health',
    'Entertainment',
    'Business',
    'Technology',
  ];

  String categoryName= 'General';
  final format = DateFormat('MMMM, dd, yy');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height *1;
    final width = MediaQuery.sizeOf(context).width *1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                  itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      categoryName = categoriesList[index];
                      setState(() {

                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoriesList[index] ?Colors.blue : Colors.grey,
                          shape: BoxShape.rectangle,
                          boxShadow: null,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(categoriesList[index].toString()),
                          ),
                        ),
                      ),
                    ),
                  );



              }),
            ),
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: FutureBuilder<NewsCategoryModel>(
                  future: newsRepository.fetchNewsCategory(categoryName),
                  builder: (BuildContext context, snapshot){

                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.blue,
                        ),
                      );
                    }else{
                      return ListView.builder(
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
                              child: Row(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        height : height * .18,
                                          width : width * .3,
                                          imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(
                                          child: SpinKitCircle(
                                            size:40,
                                            color: Colors.amber,
                                          ),
                                        ),

                                        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red,),

                                      ),

                                    ),
                                  ),

                                  Expanded(

                                    child: SizedBox(
                                      height: height * .18,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15),

                                        child: Column(

                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data!.articles![index].title.toString(),
                                            style: GoogleFonts.poppins(fontSize:14, color: Colors.black, fontWeight:FontWeight.w700),
                                            maxLines: 3,),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  style: GoogleFonts.poppins(fontSize: 10,fontWeight:FontWeight.w600),),

                                                Text(format.format(datetime), style: GoogleFonts.poppins(fontSize: 9, fontWeight:FontWeight.w500), ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
