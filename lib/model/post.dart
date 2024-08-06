import 'dart:convert';

import 'package:ashera_pet_new/model/member.dart';

class PostModel {
  final int id;
  final String body;
  final bool disableMessage;
  final int memberId;
  final MemberModel? member;
  final String pic;
  final String pics;
  final bool publish;
  final int sharePostId;
  final int postBackgroundId;
  final String createdAt;
  final String updatedAt;
  final int status;

  const PostModel({
    this.id = 0,
    required this.body,
    required this.disableMessage,
    required this.memberId,
    this.member,
    this.pic = '',
    this.pics = '',
    required this.publish,
    this.sharePostId = 0,
    this.postBackgroundId = 1,
    this.createdAt = '',
    this.updatedAt = '',
    this.status = 0,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        id: map['id'] as int? ?? 0,
        body: map['body'] as String? ?? '',
        disableMessage: map['disableMessage'] as bool? ?? false,
        memberId: map['memberId'] as int? ?? 0,
        member: MemberModel.fromMap(map['member']),
        pic: map['pic'] as String? ?? '',
        pics: map['pics'] as String? ?? '',
        publish: map['publish'] as bool? ?? true,
        sharePostId: map['sharePostId'] as int? ?? 0,
        postBackgroundId: map['postBackgroundId'] as int? ?? 1,
        createdAt: map['createdAt'] as String? ?? '',
        updatedAt: map['updatedAt'] as String? ?? '',
        status: map['status'] as int? ?? 0);
  }

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PostModel copyWith({
    int? id,
    String? body,
    bool? disableMessage,
    int? memberId,
    MemberModel? member,
    String? pic,
    String? pics,
    bool? publish,
    int? sharePostId,
    int? postBackgroundId,
    String? createdAt,
    String? updatedAt,
    int? status,
  }) {
    return PostModel(
        id: id ?? this.id,
        body: body ?? this.body,
        disableMessage: disableMessage ?? this.disableMessage,
        memberId: memberId ?? this.memberId,
        member: member ?? this.member,
        pic: pic ?? this.pic,
        pics: pics ?? this.pics,
        publish: publish ?? this.publish,
        sharePostId: sharePostId ?? this.sharePostId,
        postBackgroundId: postBackgroundId ?? this.postBackgroundId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'disableMessage': disableMessage,
      'memberId': memberId,
      'memberPetId': 0,
      'fromMemberPet': null,
      'member': member!.toMap(),
      'pic': pic,
      'pics': pics,
      'publish': publish,
      'sharePostId': sharePostId,
      'postBackgroundId': postBackgroundId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  Map<String, dynamic> addPost() {
    return {
      'body': body,
      'disableMessage': disableMessage,
      'memberId': memberId,
      'memberPetId': 0,
      'pic': pic,
      'pics': pics,
      'publish': publish,
      'sharePostId': sharePostId,
      'postBackgroundId': postBackgroundId
    };
  }

  Map<String, dynamic> editPost() {
    return {
      'id': id,
      'body': body,
      'disableMessage': disableMessage,
      'memberId': memberId,
      'memberPetId': 0,
      'pic': pic,
      'pics': pics,
      'publish': publish,
      'sharePostId': sharePostId,
      'postBackgroundId': postBackgroundId,
      'status': status,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.id == id &&
        other.body == body &&
        other.disableMessage == disableMessage &&
        other.memberId == memberId &&
        other.member == member &&
        other.pic == pic &&
        other.pics == pics &&
        other.publish == publish &&
        other.sharePostId == sharePostId &&
        other.postBackgroundId == postBackgroundId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        body.hashCode ^
        disableMessage.hashCode ^
        memberId.hashCode ^
        member.hashCode ^
        pic.hashCode ^
        pics.hashCode ^
        publish.hashCode ^
        sharePostId.hashCode ^
        postBackgroundId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        status.hashCode;
  }
}

class GetPageDTO {
  final int page;
  final int size;
  final String sortBy;

  const GetPageDTO({this.page = 0, required this.size, required this.sortBy});

  factory GetPageDTO.fromMap(Map<String, dynamic> map) {
    return GetPageDTO(
        page: map['page'] as int? ?? 0,
        size: map['size'] as int? ?? 0,
        sortBy: map['sortBy'] as String? ?? '');
  }

  factory GetPageDTO.fromJson(String source) =>
      GetPageDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  GetPageDTO copyWith({int? page, int? size, String? sortBy}) {
    return GetPageDTO(
        page: page ?? this.page,
        size: size ?? this.size,
        sortBy: sortBy ?? this.sortBy);
  }

  Map<String, dynamic> toMap() {
    return {'page': page, 'size': size, 'sortBy': sortBy};
  }

  String toJson() => json.encode(toMap());
}

class PagePostModel {
  final List<PostModel> content;
  final bool empty;
  final bool first;
  final bool last;
  final int number;
  final int numberOfElements;
  final Pageable pageable;
  final int size;
  final Sort sort;
  final int totalElements;
  final int totalPages;

  const PagePostModel(
      {required this.content,
      required this.empty,
      required this.first,
      required this.last,
      required this.number,
      required this.numberOfElements,
      required this.pageable,
      required this.size,
      required this.sort,
      required this.totalElements,
      required this.totalPages});

  factory PagePostModel.fromMap(Map<String, dynamic> map) {
    List list = map['content'];
    return PagePostModel(
        content: list.map((e) => PostModel.fromMap(e)).toList(),
        empty: map['empty'] as bool? ?? false,
        first: map['first'] as bool? ?? false,
        last: map['last'] as bool? ?? false,
        number: map['number'] as int? ?? 0,
        numberOfElements: map['numberOfElements'] as int? ?? 0,
        pageable: Pageable.fromMap(map['pageable']),
        size: map['size'] as int? ?? 0,
        sort: Sort.fromMap(map['sort']),
        totalElements: map['totalElements'] as int? ?? 0,
        totalPages: map['totalPages'] as int? ?? 0);
  }

  factory PagePostModel.fromJson(String source) =>
      PagePostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PagePostModel copyWith({
    List<PostModel>? content,
    bool? empty,
    bool? first,
    bool? last,
    int? number,
    int? numberOfElements,
    Pageable? pageable,
    int? size,
    Sort? sort,
    int? totalElements,
    int? totalPages,
  }) {
    return PagePostModel(
        content: content ?? this.content,
        empty: empty ?? this.empty,
        first: first ?? this.first,
        last: last ?? this.last,
        number: number ?? this.number,
        numberOfElements: numberOfElements ?? this.numberOfElements,
        pageable: pageable ?? this.pageable,
        size: size ?? this.size,
        sort: sort ?? this.sort,
        totalElements: totalElements ?? this.totalElements,
        totalPages: totalPages ?? this.totalPages);
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'empty': empty,
      'first': first,
      'last': last,
      'number': number,
      'numberOfElements': numberOfElements,
      'pageable': pageable,
      'size': size,
      'sort': sort,
      'totalElements': totalElements,
      'totalPages': totalPages,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PagePostModel &&
        other.content == content &&
        other.empty == empty &&
        other.first == first &&
        other.last == last &&
        other.number == number &&
        other.numberOfElements == numberOfElements &&
        other.pageable == pageable &&
        other.size == size &&
        other.sort == sort &&
        other.totalElements == totalElements &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        empty.hashCode ^
        first.hashCode ^
        last.hashCode ^
        number.hashCode ^
        numberOfElements.hashCode ^
        pageable.hashCode ^
        size.hashCode ^
        sort.hashCode ^
        totalElements.hashCode ^
        totalPages.hashCode;
  }
}

class Pageable {
  final int offset;
  final int pageNumber;
  final int pageSize;
  final bool paged;
  final Sort sort;
  final bool unpaged;

  const Pageable(
      {required this.offset,
      required this.pageNumber,
      required this.pageSize,
      required this.paged,
      required this.sort,
      required this.unpaged});

  factory Pageable.fromMap(Map<String, dynamic> map) {
    return Pageable(
        offset: map['offset'] as int? ?? 0,
        pageNumber: map['pageNumber'] as int? ?? 0,
        pageSize: map['pageSize'] as int? ?? 0,
        paged: map['paged'] as bool? ?? false,
        sort: Sort.fromMap(map['sort']),
        unpaged: map['unpaged'] as bool? ?? false);
  }

  factory Pageable.fromJson(String source) =>
      Pageable.fromMap(json.decode(source) as Map<String, dynamic>);

  Pageable copyWith(
      {int? offset,
      int? pageNumber,
      int? pageSize,
      bool? paged,
      Sort? sort,
      bool? unpaged}) {
    return Pageable(
        offset: offset ?? this.offset,
        pageNumber: pageNumber ?? this.pageNumber,
        pageSize: pageSize ?? this.pageSize,
        paged: paged ?? this.paged,
        sort: sort ?? this.sort,
        unpaged: unpaged ?? this.unpaged);
  }

  Map<String, dynamic> toMap() {
    return {
      'offset': offset,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'paged': paged,
      'sort': sort,
      'unpaged': unpaged
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pageable &&
        other.offset == offset &&
        other.pageNumber == pageNumber &&
        other.pageSize == pageSize &&
        other.paged == paged &&
        other.sort == sort &&
        other.unpaged == unpaged;
  }

  @override
  int get hashCode {
    return offset.hashCode ^
        pageNumber.hashCode ^
        pageSize.hashCode ^
        paged.hashCode ^
        sort.hashCode ^
        unpaged.hashCode;
  }
}

class Sort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  const Sort(
      {required this.empty, required this.sorted, required this.unsorted});

  factory Sort.fromMap(Map<String, dynamic> map) {
    return Sort(
        empty: map['empty'] as bool? ?? false,
        sorted: map['sorted'] as bool? ?? false,
        unsorted: map['unsorted'] as bool? ?? false);
  }

  factory Sort.fromJson(String source) =>
      Sort.fromMap(json.decode(source) as Map<String, dynamic>);

  Sort copyWith({bool? empty, bool? sorted, bool? unsorted}) {
    return Sort(
        empty: empty ?? this.empty,
        sorted: sorted ?? this.sorted,
        unsorted: unsorted ?? this.unsorted);
  }

  Map<String, dynamic> toMap() {
    return {'empty': empty, 'sorted': sorted, 'unsorted': unsorted};
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Sort &&
        other.empty == empty &&
        other.sorted == sorted &&
        other.unsorted == unsorted;
  }

  @override
  int get hashCode {
    return empty.hashCode ^ sorted.hashCode ^ unsorted.hashCode;
  }
}

class MemberPetView {
  final int id;
  final int memberId;
  final int gender;
  final String birthday;
  final String mugshot;
  final String name;
  final String nickname;

  const MemberPetView(
      {this.id = 0,
      this.memberId = 0,
      this.gender = 0,
      this.birthday = '',
      this.mugshot = '',
      this.name = '',
      this.nickname = ''});

  factory MemberPetView.fromMap(Map<String, dynamic> map) {
    return MemberPetView(
        id: map['id'] as int? ?? 0,
        memberId: map['memberId'] as int? ?? 0,
        gender: map['gender'] as int? ?? 0,
        birthday: map['birthday'] as String? ?? '',
        mugshot: map['mugshot'] as String? ?? '',
        name: map['name'] as String? ?? '',
        nickname: map['nickname'] as String? ?? '');
  }

  factory MemberPetView.fromJson(String source) =>
      MemberPetView.fromMap(json.decode(source) as Map<String, dynamic>);

  MemberPetView copyWith(
      {int? id,
      int? memberId,
      int? gender,
      String? birthday,
      String? mugshot,
      String? name,
      String? nickname}) {
    return MemberPetView(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        gender: gender ?? this.gender,
        birthday: birthday ?? this.birthday,
        mugshot: mugshot ?? this.mugshot,
        name: name ?? this.name,
        nickname: nickname ?? this.nickname);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'gender': gender,
      'birthday': birthday,
      'mugshot': mugshot,
      'name': name,
      'nickname': nickname
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemberPetView &&
        other.id == id &&
        other.memberId == memberId &&
        other.gender == gender &&
        other.birthday == birthday &&
        other.mugshot == mugshot &&
        other.name == name &&
        other.nickname == nickname;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        memberId.hashCode ^
        gender.hashCode ^
        birthday.hashCode ^
        mugshot.hashCode ^
        name.hashCode ^
        nickname.hashCode;
  }
}
