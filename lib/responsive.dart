class CheckSize {
  bool isLargeSceen(double width) {
    if (width > 1200) {
      return true;
    }
    return false;
  }

  bool isMediumScreen(double width) {
    if (width > 800 && width < 1200) {
      return true;
    }
    return false;
  }

  bool isSmallSceen(double width) {
    if (width < 800) {
      return true;
    }
    return false;
  }
}
