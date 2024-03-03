import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_details_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMM dd');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoriesScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.menu_outlined,
            size: 35,
          ),
        ),
        title: Text(
          "Newsblast",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Color(0xfffE0A3E),
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailsScreen(
                                  newsImage: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  newsTitle: snapshot.data!.articles![index].title
                                      .toString(),
                                  newsDate: snapshot
                                      .data!.articles![index].publishedAt
                                      .toString(),
                                  author: snapshot.data!.articles![index].author
                                      .toString(),
                                  description: snapshot
                                      .data!.articles![index].description
                                      .toString(),
                                  content: snapshot.data!.articles![index].content
                                      .toString(),
                                  source: snapshot
                                      .data!.articles![index].source!.name
                                      .toString()),
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.6,
                                width: width * .9,
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * .02),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: spinkit2,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    alignment: Alignment.bottomCenter,
                                    height: height * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
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
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      color: Color(0xfffE0A3E),
                      size: 30,
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.articles!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
                      );
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailsScreen(
                                  newsImage: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  newsTitle: snapshot.data!.articles![index].title
                                      .toString(),
                                  newsDate: snapshot
                                      .data!.articles![index].publishedAt
                                      .toString(),
                                  author: snapshot.data!.articles![index].author
                                      .toString(),
                                  description: snapshot
                                      .data!.articles![index].description
                                      .toString(),
                                  content: snapshot.data!.articles![index].content
                                      .toString(),
                                  source: snapshot
                                      .data!.articles![index].source!.name
                                      .toString()),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) =>
                                      const SpinKitCircle(
                                    color: Color(0xfffE0A3E),
                                    size: 30,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        maxLines: 3,
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black,
                                              // fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  size: 50,
  color: Color(0xfffE0A3E),
);
