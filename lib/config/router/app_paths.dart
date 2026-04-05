// abstract final class AppPaths {
//   static const String home = '/';
//   static const String login = '/login';
//   static const String register = '/register';
//   static const String searchListings = '/listings';
//   static const String profile = '/profile';
//   static const String apartmentDetail = '/apartment-detail';
//   static const String listingDetail = '/listings/:id';

//   static List<String> allowedPaths = List.unmodifiable([
//     home,
//     login,
//     register,
//     apartmentDetail,
//     searchListings,
//     listingDetail,
//   ]);

//   static String get initialLocation => home;
// }

enum AppPaths {
  dashboard('/', 'Dashboard'),
  login('/login', 'Login'),
  register('/register', 'Register'),
  searchListings('/listings', 'Search Listings'),
  profile('/profile', 'Profile'),
  moreScreen('/more_screen', 'More Screen'),
  listingDetail('/listings/:id', 'Listing Detail'),
  loginEmail('/login_email', 'Login Email'),
  login2('/login2', 'Login 2'),
  search('/search', 'Search');

  final String path;
  final String pathName;
  const AppPaths(this.path, this.pathName);

  static List<String> get allowedPaths => [
    AppPaths.dashboard.path,
    AppPaths.login.path,
    AppPaths.register.path,
    AppPaths.moreScreen.path,
    AppPaths.searchListings.path,
    AppPaths.listingDetail.path,
    AppPaths.search.path,
  ];

  static String get initialLocation => AppPaths.login.path;
}
