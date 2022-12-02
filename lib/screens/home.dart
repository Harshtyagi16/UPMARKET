import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_fonts/google_fonts.dart';
import 'package:upmarket/controller/AddingService.dart';
import '../controller/image_sesrvice.dart';
import 'addDetails.dart';
import 'editDetailsScreen.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final imageService = Get.put(ImageService());
final addDetailsService = Get.put(AddingService());

class _HomeState extends State<Home> {
  bool _isloading = false;

  fetchAllData() async {
    setState(() {
      _isloading = true;
    });
    await addDetailsService.fetchDetails();
    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    fetchAllData();
    super.initState();
  }

  // File? pic;

  @override
  Widget build(BuildContext context) {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // title: Center(child: Text('Wake Up',style: GoogleFonts.abrilFatface(color: Colors.black,fontSize: 20)),),
            title: Text(
              'Up Market',
              style: TextStyle(color: Colors.black),
            ),
          ),
          floatingActionButton: CircleAvatar(
              backgroundColor: Colors.black,
              child: IconButton(
                onPressed: () {
                  Get.to(() => AddDetails());
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
              )),
          body: _isloading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : GetBuilder<AddingService>(
            builder: (controller) {
              return Container(
                height: size.height,
                width: size.width,
                child: controller.allData.isEmpty ? Center(child: Text("Add Name and Image",style: GoogleFonts.lexendDeca(fontSize: 20),),):ListView.builder(
                    itemCount: controller.allData.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slidable(
                            endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                SlidableAction(
                                onPressed: (ctx) async {
                        setState(() {
                        _isloading = true;
                        });
                        Get.to(() => EditDetailsScreen(
                        id: controller.allData[i].id));
                        setState(() {
                        _isloading = false;
                        });
                        },
                            flex: 2,
                            backgroundColor: Color(0xFF7BC043).withOpacity(0.6),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                      onPressed: (ctx) async {
                      setState(() {
                      _isloading = true;
                      });
                      await controller
                          .deleteData(controller.allData[i].id);
                      setState(() {
                      _isloading = false;
                      });
                      },
                      flex: 2,
                      backgroundColor: Colors.red.withOpacity(0.6),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      ),
                      ],
                      ),
                      child: ListTile(
                      tileColor: Colors.green.withOpacity(0.4),
                      title: Text(controller.allData[i].title,style: GoogleFonts.lexendDeca(fontSize: 18),),
                      leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                      controller.allData[i].downloadUrl),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      ///EDit
                      // trailing: IconButton(
                      //     onPressed: () async {
                      //       setState(() {
                      //         _isloading = true;
                      //       });
                      //       Get.to(() => EditDetailsScreen(
                      //           id: controller.allData[i].id));
                      //       setState(() {
                      //         _isloading = false;
                      //       });
                      //     },
                      //     icon: Icon(Icons.edit)),

                      ///delete button
                      //   IconButton(
                      //       onPressed: () async {
                      //         setState(() {
                      //           _isloading = true;
                      //         });
                      //         await controller
                      //             .deleteData(controller.allData[i].id);
                      //         setState(() {
                      //           _isloading = false;
                      //         });
                      //       },
                      //       icon: Icon(Icons.delete)),
                      // ),
                      ),
                      )
                      );
                    }),
              );
            },
          )
        // Container(
        //   margin: EdgeInsets.all(10),
        //   height: size.height * 0.7,
        //   width: size.width,
        //   child: GetBuilder(
        //     init: imageService,
        //     builder: (c){
        //       return ListView.builder(itemCount: c.downloadUrlList.length,itemBuilder: (context,i){
        //         return Image.network(c.downloadUrlList[i],fit: BoxFit.cover,);
        //       });
        //     },
        //   )
        // ),
        // Container(height: size.height *0.3,
        //   child: FutureBuilder(
        //       future: imageService.viewImage('IMG_20221129_173622.jpg'),
        //       builder:(BuildContext context,AsyncSnapshot<String> snapshot){
        //
        //     if(snapshot.connectionState == ConnectionState.waiting){
        //       return Center(child: CircularProgressIndicator());
        //     }
        //     if(snapshot.hasData){
        //       return Container(height: 200,child: Image.network(snapshot.data!,fit: BoxFit.cover,),);
        //     }if(snapshot.hasError){
        //       return MaterialButton(onPressed: (){},child: Text('error'));
        //     }return SizedBox();
        //   }),
        // ),

      ),
    );
  }
}

//
