import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List list = [""];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Username',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Icon(
              Icons.add_box_outlined,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.person_add_sharp,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.menu,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Stack(
                            alignment: Alignment(1, 1),
                            children: [
                              Container(
                                child: InkWell(
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
                                    radius: 45,
                                    backgroundColor: Colors.transparent,
                                    // child: ClipOval(
                                    //   child: SizedBox(
                                    //     width: 130,
                                    //     height: 130,
                                    //     child: Image.network(
                                    //       ,
                                    //       fit: BoxFit.fill,
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("100",
                                  style: Theme.of(context).textTheme.headline6),
                              Text('Posts'),
                            ],
                          ),
                          Column(
                            children: [
                              Text("2k",
                                  style: Theme.of(context).textTheme.headline6),
                              Text('Followers'),
                            ],
                          ),
                          Column(
                            children: [
                              Text("234",
                                  style: Theme.of(context).textTheme.headline6),
                              Text('Following'),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Rishabh kumar'),
                              ],
                            ),
                            Row(
                              children: [Text('Live and let live....')],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black38),
                          ),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Icon(
                        Icons.grid_on,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                        child: Icon(
                      Icons.assignment_ind_rounded,
                      color: Colors.black,
                    )),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    GridView.builder(
                      itemCount: 100,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(child: Text("$index"));
                      },
                    ),
                    GridView.builder(
                      itemCount: 100,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(child: Text("$index"));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar:
            BottomNavigationBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.black,
              ),
              tooltip: "Home",
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.black),
              tooltip: "Search",
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation_outlined, color: Colors.black),
              tooltip: "Movie",
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined, color: Colors.black),
              tooltip: "Favourite",
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined, color: Colors.black),
              tooltip: "Profile",
              label: "Home"),
        ]),
      ),
    );
  }
}
