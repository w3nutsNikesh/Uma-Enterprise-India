// To parse this JSON data, do
//
//     final versionCodeResponse = versionCodeResponseFromJson(jsonString);

import 'dart:convert';

VersionCodeResponse versionCodeResponseFromJson(String str) => VersionCodeResponse.fromJson(json.decode(str));

String versionCodeResponseToJson(VersionCodeResponse data) => json.encode(data.toJson());

class VersionCodeResponse {
  List<Data>? data;
  Meta? meta;

  VersionCodeResponse({
    this.data,
    this.meta,
  });

  factory VersionCodeResponse.fromJson(Map<String, dynamic> json) => VersionCodeResponse(
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "meta": meta?.toJson() ?? {},
      };
}

class Data {
  int? id;
  String? android;
  String? ios;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? appstoreUrl;

  Data({
    this.id,
    this.android,
    this.ios,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.appstoreUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        android: json["android"],
        ios: json["ios"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        appstoreUrl: json["appstore_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "android": android,
        "ios": ios,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "publishedAt": publishedAt.toString(),
        "appstore_url": appstoreUrl.toString(),
      };
}

class Meta {
  Pagination? pagination;

  Meta({
    this.pagination,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(
          json["pagination"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson() ?? {},
      };
}

class Pagination {
  int? page;
  int? pageSize;
  int? pageCount;
  int? total;

  Pagination({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        pageCount: json["pageCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "pageCount": pageCount,
        "total": total,
      };
}
