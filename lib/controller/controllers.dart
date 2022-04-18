import 'package:sofiqe/controller/msProfileController.dart';
import 'package:sofiqe/controller/questionController.dart';
import 'package:sofiqe/provider/make_over_provider.dart';
import 'package:sofiqe/provider/wishlist_provider.dart';

///Controller instance
///There are 4 controller instance we will use over whole app like global Controllers
///These are static instance of controller

MsProfileController profileController = MsProfileController.instance;
MakeOverProvider makeOverProvider = MakeOverProvider.instance;
QuestionsController questionsController = QuestionsController.instance;
WishListProvider wishListProvider = WishListProvider.instance;
