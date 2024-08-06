import 'package:ashera_pet_new/enum/tab_bar.dart';
import 'package:ashera_pet_new/model/face_detect.dart';
import 'package:ashera_pet_new/model/hero_view_params.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/page/bottom_navigation/chat/photos_and_videos.dart';
import 'package:ashera_pet_new/page/bottom_navigation/home/notify.dart';
import 'package:ashera_pet_new/page/bottom_navigation/home/search/other_member_pets.dart';
import 'package:ashera_pet_new/page/bottom_navigation/home/search/search_me.dart';
import 'package:ashera_pet_new/page/bottom_navigation/home/search/search_pet.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me/add_pet_profile.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me/follower.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me/look_pet_profile.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me/map.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me/other_pet_follower.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me/user_profile.dart';
import 'package:ashera_pet_new/page/bottom_navigation/ranking/single_post.dart';
import 'package:ashera_pet_new/page/bottom_navigation/scan.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me/edit_pet_profile.dart';
import 'package:ashera_pet_new/page/bottom_navigation/scan/identification_result.dart';
import 'package:ashera_pet_new/page/login_ashera.dart';
import 'package:ashera_pet_new/page/menu/about_us.dart';
import 'package:ashera_pet_new/page/menu/change_password.dart';
import 'package:ashera_pet_new/page/comments.dart';
import 'package:ashera_pet_new/page/forget_password.dart';
import 'package:ashera_pet_new/page/login.dart';
import 'package:ashera_pet_new/page/register.dart';
import 'package:ashera_pet_new/page/register_member.dart';
import 'package:ashera_pet_new/page/register_pet.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/widget/adopt_record/record_data/report_data.dart';
import 'package:ashera_pet_new/widget/photo_and_video_view/photo_and_video_view.dart';
import 'package:ashera_pet_new/widget/photos_and_videos/list_photo_viewer.dart';
import 'package:ashera_pet_new/widget/search/hero_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../model/follower.dart';
import '../model/list_photo_viewer.dart';
import '../model/member.dart';
import '../model/post.dart';
import '../page/bottom_navigation/pet_radar/collection.dart';
import '../page/bottom_navigation/pet_radar/like.dart';
import '../page/bottom_navigation/pet_radar/map.dart';
import '../page/bottom_navigation/pet_radar/pet_magazine_content.dart';
import '../page/bottom_navigation/edit_post.dart';
import '../page/bottom_navigation/explore.dart';
import '../page/bottom_navigation/me/pet_more_pic.dart';
import '../page/bottom_navigation/scan/identification_list.dart';
import '../page/bottom_navigation/share_post.dart';
import '../page/menu/adopt_record.dart';
import '../page/menu/block_list.dart';
import '../page/bottom_navigation/home/new_post.dart';
import '../page/bottom_navigation.dart';
import '../page/bottom_navigation/home/search.dart';
import '../page/menu/comments_and_feedback.dart';
import '../page/menu/edit_user_profile.dart';
import '../page/menu/identification_record.dart';
import '../page/splash.dart';
import '../widget/adopt_record/record_data/reported_data.dart';
import '../widget/network_video_hero_view.dart';
import '../widget/new_post/file_hero_view.dart';
import '../widget/new_post/video_hero_view.dart';

class AppRouter {
  static BuildContext get ctx =>
      config.routerDelegate.navigatorKey.currentContext!;

  //是否包含
  static bool isContain(String name) =>
      config.routerDelegate.currentConfiguration.matches
          .where((element) => element.matchedLocation == name)
          .isNotEmpty;

  //
  static bool isInPage(String name) => currentLocation == name;

  static String currentLocation = config.routerDelegate.currentConfiguration.uri.toString();

  static final config = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: RouteName.splash,
    routes: [
      //歡迎畫面
      GoRoute(
        name: RouteName.splash,
        path: RouteName.splash,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              key: state.pageKey,
              child: const SplashPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        },
      ),
      //登入
      GoRoute(
          name: RouteName.login,
          path: RouteName.login,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const LoginPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      GoRoute(
          name: RouteName.loginAshera,
          path: RouteName.loginAshera,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const LoginAsheraPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //忘記密碼
      GoRoute(
          name: RouteName.forgetPassword,
          path: RouteName.forgetPassword,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const ForgetPasswordPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //更換密碼
      GoRoute(
          name: RouteName.changePassword,
          path: RouteName.changePassword,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const ChangePassword(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //主畫面
      GoRoute(
          name: RouteName.bottomNavigation,
          path: RouteName.bottomNavigation,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const BottomNavigationPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //註冊帳號、密碼
      GoRoute(
          name: RouteName.register,
          path: RouteName.register,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const RegisterPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //註冊會員資料
      GoRoute(
          name: RouteName.registerMember,
          path: RouteName.registerMember,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const RegisterMemberPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      GoRoute(
          name: RouteName.registerPet,
          path: RouteName.registerPet,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const RegisterPetPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //發布貼文
      GoRoute(
          name: RouteName.newPost,
          path: RouteName.newPost,
          builder: (context, state) {
            int sharedPostId = state.extra as int;
            return NewPostPage(
              sharedPostId: sharedPostId,
            );
          }
          /*pageBuilder: (context, state) {
            List<PostCardMediaModel> list =
                state.extra as List<PostCardMediaModel>;
            return CustomTransitionPage(
                key: state.pageKey,
                child: NewPostPage(
                  postMediaList: list,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //搜尋
      GoRoute(
        name: RouteName.search,
        path: RouteName.search,
        builder: (context, state) => const SearchPage(),
        /*pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const SearchPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
      ),
      //意見及問題反饋
      GoRoute(
        name: RouteName.commentsAndFeedback,
        path: RouteName.commentsAndFeedback,
        builder: (context, state) => const CommentsAndFeedback(),
        /*pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const CommentsAndFeedback(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
      ),
      //黑名單
      GoRoute(
        name: RouteName.blockList,
        path: RouteName.blockList,
        builder: (context, state) => const BlockList(),
        /*pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const BlockList(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
      ),
      //領養檢舉
      GoRoute(
        name: RouteName.adoptRecord,
        path: RouteName.adoptRecord,
        builder: (context, state) => const AdoptRecordPage(),
      ),
      //領養檢舉內容
      GoRoute(
          name: RouteName.adoptRecordData,
          path: RouteName.adoptRecordData,
          builder: (context, state) => const ReportData()),
      //被領養檢舉內容
      GoRoute(
          name: RouteName.adoptedRecordData,
          path: RouteName.adoptedRecordData,
          builder: (context, state) => const ReportedData()),
      //通知
      GoRoute(
        name: RouteName.notify,
        path: RouteName.notify,
        builder: (context, state) => const NotifyPage(),
        /*pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const NotifyPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
      ),
      //編輯個人資料
      GoRoute(
        name: RouteName.editUserProfile,
        path: RouteName.editUserProfile,
        builder: (context, state) => const EditUserProfile(),
        /*pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const EditUserProfile(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
      ),
      //編輯寵物資料
      GoRoute(
        name: RouteName.editPetProfile,
        path: RouteName.editPetProfile,
        builder: (context, state) => const EditPetProfile(),
        /*pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const EditPetProfile(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
      ),
      //新增寵物資料
      GoRoute(
        name: RouteName.addPetProfile,
        path: RouteName.addPetProfile,
        builder: (context, state) => const AddPetProfile(),
        /*pageBuilder: (context, state){
          return CustomTransitionPage(
              key: state.pageKey,
              child: const AddPetProfile(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
      ),
      //關於AsheraPet
      GoRoute(
        name: RouteName.aboutUs,
        path: RouteName.aboutUs,
        builder: (context, state) => const AboutUsPage(),
        /*pageBuilder: (context, state){
          return CustomTransitionPage(
              key: state.pageKey,
              child: const AboutUsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
      ),
      //辨識紀錄
      GoRoute(
          name: RouteName.identificationRecord,
          path: RouteName.identificationRecord,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const IdentificationRecord(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //辨識結果列表
      GoRoute(
          name: RouteName.identificationList,
          path: RouteName.identificationList,
          pageBuilder: (context, state) {
            List<FaceDetectResponseModel> data =
                state.extra as List<FaceDetectResponseModel>;
            return CustomTransitionPage(
                key: state.pageKey,
                child: IdentificationList(
                  data: data,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //辨識結果寵物資訊
      GoRoute(
          name: RouteName.identificationResult,
          path: RouteName.identificationResult,
          pageBuilder: (context, state) {
            MemberPetModel data = state.extra as MemberPetModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: IdentificationResult(
                  data: data,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //辨識相機
      GoRoute(
          name: RouteName.scan,
          path: RouteName.scan,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                key: state.pageKey,
                child: const ScanPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }),
      //按讚
      GoRoute(
        name: RouteName.like,
        path: RouteName.like,
        builder: (context, state) => const LikePage(),
        /*pageBuilder: (context, state){
            return CustomTransitionPage(
                key: state.pageKey,
                child: const LikePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          },*/
      ),
      //珍藏
      GoRoute(
        name: RouteName.collection,
        path: RouteName.collection,
        builder: (context, state) => const CollectionPage(),
        /*pageBuilder: (context, state){
            return CustomTransitionPage(
                key: state.pageKey,
                child: const CollectionPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
      ),
      //寵刊內容
      GoRoute(
          name: RouteName.petMagazineContent,
          path: RouteName.petMagazineContent,
          builder: (context, state) {
            MemberPetModel pet = state.extra as MemberPetModel;
            return PetMagazineContentPage(pet: pet);
          }
          /*pageBuilder: (context, state){
            MemberPetModel pet = state.extra as MemberPetModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: PetMagazineContentPage(pet: pet),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //搜尋結果-自己
      GoRoute(
        name: RouteName.searchMe,
        path: RouteName.searchMe,
        builder: (context, state) => const SearchMePage(),
        /*pageBuilder: (context, state){
          return CustomTransitionPage(
              key: state.pageKey,
              child: const SearchMePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
      ),
      //搜尋結果
      GoRoute(
          name: RouteName.searchPet,
          path: RouteName.searchPet,
          builder: (context, state) {
            MemberModel data = state.extra as MemberModel;
            return SearchPetPage(
              userData: data,
            );
          }
          /*pageBuilder: (context, state) {
            MemberModel data = state.extra as MemberModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: SearchPetPage(
                  userData: data,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //
      GoRoute(
          name: RouteName.userProfile,
          path: RouteName.userProfile,
          builder: (context, state) {
            MemberModel data = state.extra as MemberModel;
            return UserProfile(
              userData: data,
            );
          }),
      //跟隨與追蹤
      GoRoute(
          name: RouteName.follower,
          path: RouteName.follower,
          builder: (context, state) {
            FollowerTabBarEnum type = state.extra as FollowerTabBarEnum;
            return FollowerPage(
              type: type,
            );
          }
          /*pageBuilder: (context, state){
          FollowerTabBarEnum type = state.extra as FollowerTabBarEnum;
          return CustomTransitionPage(
              key: state.pageKey,
              child: FollowerPage(
                type: type,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
          ),
      //其他寵物跟隨與追蹤
      GoRoute(
          name: RouteName.otherFollower,
          path: RouteName.otherFollower,
          builder: (context, state) {
            OtherPetFollowerModel data = state.extra as OtherPetFollowerModel;
            return OtherPetFollower(
              data: data,
            );
          }
          /*pageBuilder: (context, state){
            OtherPetFollowerModel data = state.extra as OtherPetFollowerModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: OtherPetFollower(
                  data: data,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //聊天室
      /*GoRoute(
          name: RouteName.room,
          path: RouteName.room,
          builder: (context, state) {
            MemberAndMsgLast data = state.extra as MemberAndMsgLast;
            return RoomPage(
              userData: data,
            );
          }),*/
      //留言
      GoRoute(
          name: RouteName.comments,
          path: RouteName.comments,
          builder: (context, state) {
            PostModel models = state.extra as PostModel;
            return CommentsPage(
              postCardData: models,
            );
          }
          /*pageBuilder: (context, state) {
            PostModel models = state.extra as PostModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: CommentsPage(
                  postCardData: models,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //探索
      GoRoute(
          name: RouteName.explore,
          path: RouteName.explore,
          builder: (context, state) {
            PostModel data = state.extra as PostModel;
            return ExplorePage(
              postData: data,
            );
          }
          /*pageBuilder: (context, state){
          PostModel data = state.extra as PostModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: ExplorePage(
                postData: data,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
          ),
      //NetWorkHero
      GoRoute(
          name: RouteName.netWorkImageHeroView,
          path: RouteName.netWorkImageHeroView,
          builder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return NetworkImageHeroView(paramsModel: models);
          }
          /*pageBuilder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: NetworkImageHeroView(paramsModel: models),
                transitionDuration: const Duration(milliseconds: 1000),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //分享貼文
      GoRoute(
          name: RouteName.sharePost,
          path: RouteName.sharePost,
          builder: (context, state) {
            String postId = state.extra as String;
            return SharePost(postId: postId);
          }
          /*pageBuilder: (context, state){
          String postId = state.extra as String;
          return CustomTransitionPage(
              key: state.pageKey,
              child: SharePost(postId: postId),
              transitionDuration: const Duration(milliseconds: 1000),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              }
          );
        }*/
          ),
      //單篇貼文
      GoRoute(
          name: RouteName.singlePost,
          path: RouteName.singlePost,
          builder: (context, state) {
            String postId = state.extra as String;
            return SinglePost(postId: postId);
          }
          /*pageBuilder: (context, state){
          String postId = state.extra as String;
          return CustomTransitionPage(
              key: state.pageKey,
              child: SinglePost(postId: postId),
              transitionDuration: const Duration(milliseconds: 1000),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              }
          );
        }*/
          ),
      //FileHero
      GoRoute(
          name: RouteName.fileHeroView,
          path: RouteName.fileHeroView,
          builder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return FileHeroView(
              paramsModel: models,
            );
          }
          /*pageBuilder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: FileHeroView(
                  paramsModel: models,
                ),
                transitionDuration: const Duration(milliseconds: 1000),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //VideoHero
      GoRoute(
          name: RouteName.videoHeroView,
          path: RouteName.videoHeroView,
          builder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return VideoHeroView(
              paramsModel: models,
            );
          }
          /*pageBuilder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: VideoHeroView(
                  paramsModel: models,
                ),
                transitionDuration: const Duration(milliseconds: 1000),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      //NetworkVideoHero
      GoRoute(
          name: RouteName.netWorkVideoHeroView,
          path: RouteName.netWorkVideoHeroView,
          builder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return NetworkVideoHeroView(
              paramsModel: models,
            );
          }
          /*pageBuilder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return CustomTransitionPage(
                key: state.pageKey,
                child: NetworkVideoHeroView(
                  paramsModel: models,
                ),
                transitionDuration: const Duration(milliseconds: 1000),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          }*/
          ),
      GoRoute(
          name: RouteName.photoAndVideoView,
          path: RouteName.photoAndVideoView,
          builder: (context, state) {
            HeroViewParamsModel models = state.extra as HeroViewParamsModel;
            return PhotoAndVideoView(
              paramsModel: models,
            );
          }
          /*pageBuilder: (context, state){
          HeroViewParamsModel models = state.extra as HeroViewParamsModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: PhotoAndVideoView(
                paramsModel: models,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child){
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              }
          );
        }*/
          ),
      GoRoute(
          name: RouteName.photosAndVideosRecord,
          path: RouteName.photosAndVideosRecord,
          builder: (context, state) => const PhotosAndVideosPage()),
      GoRoute(
          name: RouteName.listPhotoViewer,
          path: RouteName.listPhotoViewer,
          builder: (context, state) {
            ListPhotoViewerModel models = state.extra as ListPhotoViewerModel;
            return ListPhotoViewer(id: models.id);
          }
          /*pageBuilder: (context, state){
          ListPhotoViewerModel models = state.extra as ListPhotoViewerModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: ListPhotoViewer(id: models.id),
              transitionsBuilder: (context, animation, secondaryAnimation, child){
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
          ),
      //看寵物資料
      GoRoute(
        name: RouteName.lookPetProfile,
        path: RouteName.lookPetProfile,
        builder: (context, state) {
          MemberPetModel pet = state.extra as MemberPetModel;
          return LookPetProfilePage(pet: pet);
        },
        /*pageBuilder: (context, state){
          MemberPetModel pet = state.extra as MemberPetModel;
          return CustomTransitionPage(
              key: state.pageKey,
              child: LookPetProfilePage(pet: pet,),
              transitionsBuilder: (context, animation, secondaryAnimation, child){
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
      ),
      //更多寵物相片
      GoRoute(
        name: RouteName.petMorePic,
        path: RouteName.petMorePic,
        builder: (context, state) => const PetMorePicPage(),
        /*pageBuilder: (context, state){
          return CustomTransitionPage(
              key: state.pageKey,
              child: const PetMorePicPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child){
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
      ),
      //petMap
      GoRoute(
        name: RouteName.petMap,
        path: RouteName.petMap,
        builder: (context, state) => const MapPage(),
        /*pageBuilder: (context, state){
          return CustomTransitionPage(
              key: state.pageKey,
              child: const MapPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child){
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              });
        }*/
      ),
      //其他會員寵物列表
      GoRoute(
          name: RouteName.otherMemberPets,
          path: RouteName.otherMemberPets,
          builder: (context, state) {
            List<MemberPetModel> pets = state.extra as List<MemberPetModel>;
            return OtherMemberPets(pets: pets);
          }),
      //自我寵物地圖
      GoRoute(
          name: RouteName.editPetMap,
          path: RouteName.editPetMap,
          builder: (context, state) => const EditPetMapPage()),
      //編輯貼文
      GoRoute(
          name: RouteName.editPost,
          path: RouteName.editPost,
          builder: (context, state) {
            PostModel model = state.extra as PostModel;
            return EditPostPage(
              model: model,
            );
          })
    ],
  );

  static Future<bool> pop() async {
    if (ctx.canPop()) {
      ctx.pop();
      return Future.value(true);
    }
    return await _confirmExit();
  }

  static Future<bool> _confirmExit() async {
    return true;
  }
}
