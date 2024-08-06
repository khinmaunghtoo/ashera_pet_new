import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/member.dart';
import '../../../utils/api.dart';
import '../../../utils/app_image.dart';
import '../../../utils/utils.dart';

/// An avatar that displays a user's profile picture.
///
/// Supports different sizes:
/// - `Avatar.tiny`
/// - `Avatar.small`
/// - `Avatar.medium`
/// - `Avatar.big`
/// - `Avatar.huge`
///
class Avatar extends StatelessWidget {
  /// Indicates if the user has a new story. If yes, their avatar is surrounded
  /// with an indicator.
  final bool hasNewStory;

  /// The user data to show for the avatar.
  final MemberModel user;

  /// Text size of the user's initials when there is no profile photo.
  final double fontSize;

  final double _avatarSize;
  final double _coloredCircle;

  // Tiny avatar configuration
  static const _tinyAvatarSize = 22.0;
  static const _tinyPaddedCircle = _tinyAvatarSize + 2;
  static const _tinyColoredCircle = _tinyPaddedCircle * 2 + 4;

  // Small avatar configuration
  static const _smallAvatarSize = 32.0;
  static const _smallPaddedCircle = _smallAvatarSize + 2;
  static const _smallColoredCircle = _smallPaddedCircle * 2 + 4;

  // Medium avatar configuration
  static const _mediumAvatarSize = 50.0;
  static const _mediumPaddedCircle = _mediumAvatarSize + 2;
  static const _mediumColoredCircle = _mediumPaddedCircle * 2 + 4;

  // Large avatar configuration
  static const _largeAvatarSize = 90.0;
  static const _largPaddedCircle = _largeAvatarSize + 2;
  static const _largeColoredCircle = _largPaddedCircle * 2 + 4;

  // Huge avatar configuration
  static const _hugeAvatarSize = 120.0;
  static const _hugePaddedCircle = _hugeAvatarSize + 2;
  static const _hugeColoredCircle = _hugePaddedCircle * 2 + 4;

  /// Whether this avatar uses a thumbnail as an image (low quality).
  final bool isThumbnail;

  final VoidCallback? callback;

  /// Creates a tiny avatar.
  const Avatar.tiny({super.key, required this.user, this.callback})
      : _avatarSize = _tinyAvatarSize,
        _coloredCircle = _tinyColoredCircle,
        hasNewStory = false,
        fontSize = 12,
        isThumbnail = true;

  /// Creates a small avatar.
  const Avatar.small({super.key, required this.user, this.callback})
      : _avatarSize = _smallAvatarSize,
        _coloredCircle = _smallColoredCircle,
        hasNewStory = false,
        fontSize = 14,
        isThumbnail = true;

  /// Creates a medium avatar.
  const Avatar.medium(
      {super.key, this.hasNewStory = false, required this.user, this.callback})
      : _avatarSize = _mediumAvatarSize,
        _coloredCircle = _mediumColoredCircle,
        fontSize = 20,
        isThumbnail = true;

  /// Creates a big avatar.
  const Avatar.big(
      {super.key, this.hasNewStory = false, required this.user, this.callback})
      : _avatarSize = _largeAvatarSize,
        _coloredCircle = _largeColoredCircle,
        fontSize = 26,
        isThumbnail = false;

  /// Creates a huge avatar.
  const Avatar.huge(
      {super.key, this.hasNewStory = false, required this.user, this.callback})
      : _avatarSize = _hugeAvatarSize,
        _coloredCircle = _hugeColoredCircle,
        fontSize = 30,
        isThumbnail = false;

  @override
  Widget build(BuildContext context) {
    final picture = _CircularProfilePicture(
      size: _avatarSize,
      userData: user,
      fontSize: fontSize,
      isThumbnail: isThumbnail,
      callback: callback,
    );

    if (!hasNewStory) {
      return picture;
    }
    return Container(
      width: _coloredCircle,
      height: _coloredCircle,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(child: picture),
    );
  }
}

class _CircularProfilePicture extends StatelessWidget {
  const _CircularProfilePicture(
      {required this.size,
      required this.userData,
      required this.fontSize,
      this.isThumbnail = false,
      this.callback});

  final MemberModel userData;

  final double size;
  final double fontSize;

  final bool isThumbnail;

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    final profilePhoto = isThumbnail ? userData.mugshot : userData.mugshot;
    return (profilePhoto.isEmpty)
        ? GestureDetector(
            onTap: callback,
            child: _noData(),
          )
        : GestureDetector(
            onTap: callback,
            child: SizedBox(
              height: size,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: Utils.getFilePath(userData.mugshot),
                    httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
                    errorWidget: (context, url, _) {
                      return GestureDetector(
                        onTap: callback,
                        child: _noData(),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }

  Widget _noData() {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: const BoxDecoration(
        color: AppColor.textFieldHintText,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Image(
          image: AssetImage(AppImage.logoWhite),
        ),
      ),
    );
  }
}
