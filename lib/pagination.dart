  int number = 1;
  List<DocumentSnapshot> users = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 15;
  DocumentSnapshot? lastDocument;
  ScrollController _scrollController = ScrollController();

  getProducts() async {
    if (!hasMore) {
      print('No More Users');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(documentLimit)
          .get();
      setState(() {
        isLoading = false;
      });
    } else {
      querySnapshot = await firestore
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      setState(() {
        isLoading = false;
      });
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    users.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  initState() {
    getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.30;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
        setState(() {
          number++;
        });
      }
    });
    super.initState();
  }
