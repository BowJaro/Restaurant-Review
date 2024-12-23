import 'package:get/get.dart';
import 'package:restaurant_review/modules/brand_detail/binding/brand_detail_binding.dart';
import 'package:restaurant_review/modules/brand_detail/view/brand_detail_view.dart';
import 'package:restaurant_review/modules/brand_page/binding/brand_page_binding.dart';
import 'package:restaurant_review/modules/brand_page/view/brand_page_view.dart';
import 'package:restaurant_review/modules/comment/binding/comment_binding.dart';
import 'package:restaurant_review/modules/comment/view/comment_view.dart';
import 'package:restaurant_review/modules/explore/binding/explore_binding.dart';
import 'package:restaurant_review/modules/explore/view/explore_view.dart';
import 'package:restaurant_review/modules/feedback/binding/feedback_binding.dart';
import 'package:restaurant_review/modules/feedback/view/report_view.dart';
import 'package:restaurant_review/modules/following/binding/following_binding.dart';
import 'package:restaurant_review/modules/following/view/following_view.dart';
import 'package:restaurant_review/modules/home/binding/home_binding.dart';
import 'package:restaurant_review/modules/home/view/home_view.dart';
import 'package:restaurant_review/modules/menu_creation/binding/menu_creation_binding.dart';
import 'package:restaurant_review/modules/menu_creation/view/menu_creation_view.dart';
import 'package:restaurant_review/modules/menu_view/binding/menu_view_binding.dart';
import 'package:restaurant_review/modules/menu_view/view/menu_view_view.dart';
import 'package:restaurant_review/modules/my_post/binding/my_post_binding.dart';
import 'package:restaurant_review/modules/my_post/view/my_post_view.dart';
import 'package:restaurant_review/modules/notification/binding/notification_binding.dart';
import 'package:restaurant_review/modules/notification/view/notification_view.dart';
import 'package:restaurant_review/modules/permission_request/binding/permission_request_binding.dart';
import 'package:restaurant_review/modules/permission_request/view/permission_request_view.dart';
import 'package:restaurant_review/modules/post/binding/post_binding.dart';
import 'package:restaurant_review/modules/post/view/post_view.dart';
import 'package:restaurant_review/modules/post_detail/binding/post_detail_binding.dart';
import 'package:restaurant_review/modules/post_detail/view/post_detail_view.dart';
import 'package:restaurant_review/modules/report/binding/report_binding.dart';
import 'package:restaurant_review/modules/report/view/report_view.dart';
import 'package:restaurant_review/modules/restaurant_detail/binding/restaurant_detail_binding.dart';
import 'package:restaurant_review/modules/restaurant_detail/view/restaurant_detail_view.dart';
import 'package:restaurant_review/modules/search/binding/search_binding.dart';
import 'package:restaurant_review/modules/search/view/search_view.dart';
import 'package:restaurant_review/modules/restaurant_management/binding/restaurant_management_binding.dart';
import 'package:restaurant_review/modules/restaurant_management/view/restaurant_management_view.dart';
import 'package:restaurant_review/modules/restaurant_page/binding/restaurant_page_binding.dart';
import 'package:restaurant_review/modules/restaurant_page/view/restaurant_page_view.dart';
import 'package:restaurant_review/modules/sign_in/binding/sign_in_binding.dart';
import 'package:restaurant_review/modules/sign_in/view/sign_in_view.dart';
import 'package:restaurant_review/modules/sign_up/binding/sign_up_binding.dart';
import 'package:restaurant_review/modules/sign_up/view/sign_up_view.dart';
import 'package:restaurant_review/modules/splash/binding/splash_binding.dart';
import 'package:restaurant_review/modules/splash/view/splash_view.dart';
import 'package:restaurant_review/modules/user/binding/user_binding.dart';
import 'package:restaurant_review/modules/user/view/user_view.dart';
import 'package:restaurant_review/modules/user_following/binding/user_following_binding.dart';
import 'package:restaurant_review/modules/user_following/view/user_following_view.dart';
import 'package:restaurant_review/modules/user_follower/binding/user_follower_binding.dart';
import 'package:restaurant_review/modules/user_follower/view/user_follower_view.dart';
import '../modules/account/binding/account_binding.dart';
import '../modules/account/view/account_view.dart';

abstract class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String language = '/language';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String postDetail = '/post_detail';
  static const String brandDetail = '/brand_detail';
  static const String restaurantDetail = '/restaurant_detail';
  static const String account = '/account';
  static const String saved = '/saved';
  static const String explore = '/explore';
  static const String comment = '/comment';
  static const String brandPage = '/brand_page';
  static const String restaurantPage = '/restaurant_page';
  static const String postPage = '/post_page';
  static const String following = '/following_page';
  static const String myPost = '/my_post_page';
  static const String report = '/report_page';
  static const String feedback = '/feedback_page';
  static const String permissionRequest = '/permission_request_page';
  static const String searchPage = '/search_page';
  static const String restaurantManagement = '/restaurant_management_page';
  static const String user = '/user';
  static const String menuView = '/menu_view';
  static const String menuCreation = '/menu_creation';
  static const String notification = '/notification';
  static const String userFollowers = '/user_followers';
  static const String userFollowing = '/user_following';
}

class AppPages {
  static const initial = Routes.signIn;
  static final routes = [
    GetPage(
      name: Routes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.postDetail,
      page: () => const PostDetailView(),
      binding: PostDetailBinding(),
    ),
    GetPage(
      name: Routes.brandDetail,
      page: () => const BrandDetailView(),
      binding: BrandDetailBinding(),
    ),
    GetPage(
      name: Routes.restaurantDetail,
      page: () => const RestaurantDetailView(),
      binding: RestaurantDetailBinding(),
    ),
    GetPage(
      name: Routes.account,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: Routes.comment,
      page: () => const CommentView(),
      binding: CommentBinding(),
    ),
    GetPage(
      name: Routes.brandPage,
      page: () => const BrandPageView(),
      binding: BrandPageBinding(),
    ),
    GetPage(
      name: Routes.following,
      page: () => const FollowingView(),
      binding: FollowingBinding(),
    ),
    GetPage(
      name: Routes.myPost,
      page: () => const MyPostView(),
      binding: MyPostBinding(),
    ),
    GetPage(
      name: Routes.report,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: Routes.feedback,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: Routes.permissionRequest,
      page: () => const PermissionRequestView(),
      binding: PermissionRequestBinding(),
    ),
    GetPage(
      name: Routes.searchPage,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition
          .noTransition, // Define no animation globally for this route
    ),
    GetPage(
      name: Routes.explore,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: Routes.restaurantManagement,
      page: () => const RestaurantManagementView(),
      binding: RestaurantManagementBinding(),
    ),
    GetPage(
      name: Routes.user,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: Routes.restaurantPage,
      page: () => const RestaurantPageView(),
      binding: RestaurantPageBinding(),
    ),
    GetPage(
      name: Routes.postPage,
      page: () => const PostView(),
      binding: PostBinding(),
    ),
    GetPage(
      name: Routes.menuView,
      page: () => const MenuViewView(),
      binding: MenuViewBinding(),
    ),
    GetPage(
      name: Routes.menuCreation,
      page: () => const MenuCreationView(),
      binding: MenuCreationBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.userFollowers,
      page: () => const UserFollowerView(),
      binding: UserFollowerBinding(),
    ),
    GetPage(
      name: Routes.userFollowing,
      page: () => const UserFollowingView(),
      binding: UserFollowingBinding(),
    ),
  ];
}
