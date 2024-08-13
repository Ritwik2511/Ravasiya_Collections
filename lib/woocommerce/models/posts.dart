// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

List<Posts?>? postsFromJson(String str) => json.decode(str) == null
    ? []
    : List<Posts?>.from(json.decode(str)!.map((x) => Posts.fromJson(x)));

String postsToJson(List<Posts?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class Posts {
  Posts({
    required this.id,
    required this.date,
    required this.dateGmt,
    required this.guid,
    required this.modified,
    required this.modifiedGmt,
    required this.slug,
    required this.status,
    required this.type,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.author,
    required this.featuredMedia,
    required this.commentStatus,
    required this.pingStatus,
    required this.sticky,
    required this.template,
    required this.format,
    required this.meta,
    required this.categories,
    required this.tags,
    required this.links,
    required this.embedded,
  });

  final int? id;
  final DateTime? date;
  final DateTime? dateGmt;
  final Guid? guid;
  final DateTime? modified;
  final DateTime? modifiedGmt;
  final String? slug;
  final String? status;
  final String? type;
  final String? link;
  final Guid? title;
  final Content? content;
  final Content? excerpt;
  final int? author;
  final int? featuredMedia;
  final String? commentStatus;
  final String? pingStatus;
  final bool? sticky;
  final String? template;
  final String? format;
  final Meta? meta;
  final List<int?>? categories;
  final List<dynamic>? tags;
  final PostLinks? links;
  final Embedded? embedded;

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        dateGmt: DateTime.parse(json["date_gmt"]),
        guid: Guid.fromJson(json["guid"]),
        modified: DateTime.parse(json["modified"]),
        modifiedGmt: DateTime.parse(json["modified_gmt"]),
        slug: json["slug"],
        status: json["status"],
        type: json["type"],
        link: json["link"],
        title: Guid.fromJson(json["title"]),
        content: Content.fromJson(json["content"]),
        excerpt: Content.fromJson(json["excerpt"]),
        author: json["author"],
        featuredMedia: json["featured_media"],
        commentStatus: json["comment_status"],
        pingStatus: json["ping_status"],
        sticky: json["sticky"],
        template: json["template"],
        format: json["format"],
        meta: Meta.fromJson(json["meta"]),
        categories: json["categories"] == null
            ? []
            : List<int?>.from(json["categories"]!.map((x) => x)),
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        links: PostLinks.fromJson(json["_links"]),
        embedded: Embedded.fromJson(json["_embedded"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "date_gmt": dateGmt?.toIso8601String(),
        "guid": guid!.toJson(),
        "modified": modified?.toIso8601String(),
        "modified_gmt": modifiedGmt?.toIso8601String(),
        "slug": slug,
        "status": status,
        "type": type,
        "link": link,
        "title": title!.toJson(),
        "content": content!.toJson(),
        "excerpt": excerpt!.toJson(),
        "author": author,
        "featured_media": featuredMedia,
        "comment_status": commentStatus,
        "ping_status": pingStatus,
        "sticky": sticky,
        "template": template,
        "format": format,
        "meta": meta!.toJson(),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x)),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "_links": links!.toJson(),
        "_embedded": embedded!.toJson(),
      };
}

class Content {
  Content({
    required this.rendered,
    required this.protected,
  });

  final String? rendered;
  final bool? protected;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
}

class Embedded {
  Embedded({
    required this.author,
    required this.wpFeaturedmedia,
    required this.wpTerm,
  });

  final List<EmbeddedAuthor?>? author;
  final List<WpFeaturedmedia?>? wpFeaturedmedia;
  final List<List<EmbeddedWpTerm?>?>? wpTerm;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        author: json["author"] == null
            ? []
            : List<EmbeddedAuthor?>.from(
                json["author"]!.map((x) => EmbeddedAuthor.fromJson(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? []
            : List<WpFeaturedmedia?>.from(json["wp:featuredmedia"]!
                .map((x) => WpFeaturedmedia.fromJson(x))),
        wpTerm: json["wp:term"] == null
            ? []
            : List<List<EmbeddedWpTerm?>?>.from(json["wp:term"]!.map((x) =>
                x == null
                    ? []
                    : List<EmbeddedWpTerm?>.from(
                        x!.map((x) => EmbeddedWpTerm.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "author": author == null
            ? []
            : List<dynamic>.from(author!.map((x) => x!.toJson())),
        "wp:featuredmedia": wpFeaturedmedia == null
            ? []
            : List<dynamic>.from(wpFeaturedmedia!.map((x) => x!.toJson())),
        "wp:term": wpTerm == null
            ? []
            : List<dynamic>.from(wpTerm!.map((x) => x == null
                ? []
                : List<dynamic>.from(x.map((x) => x!.toJson())))),
      };
}

class EmbeddedAuthor {
  EmbeddedAuthor({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.link,
    required this.slug,
    required this.isSuperAdmin,
  });

  final int? id;
  final String? name;
  final String? url;
  final String? description;
  final String? link;
  final String? slug;
  final bool? isSuperAdmin;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) => EmbeddedAuthor(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        description: json["description"],
        link: json["link"],
        slug: json["slug"],
        isSuperAdmin: json["is_super_admin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "description": description,
        "link": link,
        "slug": slug,
        "is_super_admin": isSuperAdmin,
      };
}

class AuthorLinks {
  AuthorLinks({
    required this.self,
    required this.collection,
  });

  final List<About?>? self;
  final List<About?>? collection;

  factory AuthorLinks.fromJson(Map<String, dynamic> json) => AuthorLinks(
        self: json["self"] == null
            ? []
            : List<About?>.from(json["self"]!.map((x) => About.fromJson(x))),
        collection: json["collection"] == null
            ? []
            : List<About?>.from(
                json["collection"]!.map((x) => About.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? []
            : List<dynamic>.from(self!.map((x) => x!.toJson())),
        "collection": collection == null
            ? []
            : List<dynamic>.from(collection!.map((x) => x!.toJson())),
      };
}

class About {
  About({
    required this.href,
  });

  final String? href;

  factory About.fromJson(Map<String, dynamic> json) => About(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class WoocommerceMeta {
  WoocommerceMeta({
    required this.activityPanelInboxLastRead,
    required this.activityPanelReviewsLastRead,
    required this.categoriesReportColumns,
    required this.couponsReportColumns,
    required this.customersReportColumns,
    required this.ordersReportColumns,
    required this.productsReportColumns,
    required this.revenueReportColumns,
    required this.taxesReportColumns,
    required this.variationsReportColumns,
    required this.dashboardSections,
    required this.dashboardChartType,
    required this.dashboardChartInterval,
    required this.dashboardLeaderboardRows,
    required this.homepageLayout,
    required this.homepageStats,
    required this.taskListTrackedStartedTasks,
    required this.helpPanelHighlightShown,
    required this.androidAppBannerDismissed,
  });

  final String? activityPanelInboxLastRead;
  final String? activityPanelReviewsLastRead;
  final String? categoriesReportColumns;
  final String? couponsReportColumns;
  final String? customersReportColumns;
  final String? ordersReportColumns;
  final String? productsReportColumns;
  final String? revenueReportColumns;
  final String? taxesReportColumns;
  final String? variationsReportColumns;
  final String? dashboardSections;
  final String? dashboardChartType;
  final String? dashboardChartInterval;
  final String? dashboardLeaderboardRows;
  final String? homepageLayout;
  final String? homepageStats;
  final String? taskListTrackedStartedTasks;
  final String? helpPanelHighlightShown;
  final String? androidAppBannerDismissed;

  factory WoocommerceMeta.fromJson(Map<String, dynamic> json) =>
      WoocommerceMeta(
        activityPanelInboxLastRead: json["activity_panel_inbox_last_read"],
        activityPanelReviewsLastRead: json["activity_panel_reviews_last_read"],
        categoriesReportColumns: json["categories_report_columns"],
        couponsReportColumns: json["coupons_report_columns"],
        customersReportColumns: json["customers_report_columns"],
        ordersReportColumns: json["orders_report_columns"],
        productsReportColumns: json["products_report_columns"],
        revenueReportColumns: json["revenue_report_columns"],
        taxesReportColumns: json["taxes_report_columns"],
        variationsReportColumns: json["variations_report_columns"],
        dashboardSections: json["dashboard_sections"],
        dashboardChartType: json["dashboard_chart_type"],
        dashboardChartInterval: json["dashboard_chart_interval"],
        dashboardLeaderboardRows: json["dashboard_leaderboard_rows"],
        homepageLayout: json["homepage_layout"],
        homepageStats: json["homepage_stats"],
        taskListTrackedStartedTasks: json["task_list_tracked_started_tasks"],
        helpPanelHighlightShown: json["help_panel_highlight_shown"],
        androidAppBannerDismissed: json["android_app_banner_dismissed"],
      );

  Map<String, dynamic> toJson() => {
        "activity_panel_inbox_last_read": activityPanelInboxLastRead,
        "activity_panel_reviews_last_read": activityPanelReviewsLastRead,
        "categories_report_columns": categoriesReportColumns,
        "coupons_report_columns": couponsReportColumns,
        "customers_report_columns": customersReportColumns,
        "orders_report_columns": ordersReportColumns,
        "products_report_columns": productsReportColumns,
        "revenue_report_columns": revenueReportColumns,
        "taxes_report_columns": taxesReportColumns,
        "variations_report_columns": variationsReportColumns,
        "dashboard_sections": dashboardSections,
        "dashboard_chart_type": dashboardChartType,
        "dashboard_chart_interval": dashboardChartInterval,
        "dashboard_leaderboard_rows": dashboardLeaderboardRows,
        "homepage_layout": homepageLayout,
        "homepage_stats": homepageStats,
        "task_list_tracked_started_tasks": taskListTrackedStartedTasks,
        "help_panel_highlight_shown": helpPanelHighlightShown,
        "android_app_banner_dismissed": androidAppBannerDismissed,
      };
}

class WpFeaturedmedia {
  WpFeaturedmedia({
    required this.id,
    required this.date,
    required this.slug,
    required this.type,
    required this.link,
    required this.title,
    required this.author,
    required this.caption,
    required this.altText,
    required this.mediaType,
    required this.mimeType,
    required this.mediaDetails,
    required this.sourceUrl,
    required this.links,
  });

  final int? id;
  final DateTime? date;
  final String? slug;
  final String? type;
  final String? link;
  final Guid? title;
  final int? author;
  final Guid? caption;
  final String? altText;
  final String? mediaType;
  final MimeType? mimeType;
  final MediaDetails? mediaDetails;
  final String? sourceUrl;
  final WpFeaturedmediaLinks? links;

  factory WpFeaturedmedia.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmedia(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        slug: json["slug"],
        type: json["type"],
        link: json["link"],
        title: Guid.fromJson(json["title"]),
        author: json["author"],
        caption: Guid.fromJson(json["caption"]),
        altText: json["alt_text"],
        mediaType: json["media_type"],
        mimeType: mimeTypeValues.map[json["mime_type"]],
        mediaDetails: MediaDetails.fromJson(json["media_details"]),
        sourceUrl: json["source_url"],
        links: WpFeaturedmediaLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "slug": slug,
        "type": type,
        "link": link,
        "title": title!.toJson(),
        "author": author,
        "caption": caption!.toJson(),
        "alt_text": altText,
        "media_type": mediaType,
        "mime_type": mimeTypeValues.reverse![mimeType],
        "media_details": mediaDetails!.toJson(),
        "source_url": sourceUrl,
        "_links": links!.toJson(),
      };
}

class Guid {
  Guid({
    required this.rendered,
  });

  final String? rendered;

  factory Guid.fromJson(Map<String, dynamic> json) => Guid(
        rendered: json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
      };
}

class WpFeaturedmediaLinks {
  WpFeaturedmediaLinks({
    required this.self,
    required this.collection,
    required this.about,
    required this.author,
    required this.replies,
  });

  final List<About?>? self;
  final List<About?>? collection;
  final List<About?>? about;
  final List<ReplyElement?>? author;
  final List<ReplyElement?>? replies;

  factory WpFeaturedmediaLinks.fromJson(Map<String, dynamic> json) =>
      WpFeaturedmediaLinks(
        self: json["self"] == null
            ? []
            : List<About?>.from(json["self"]!.map((x) => About.fromJson(x))),
        collection: json["collection"] == null
            ? []
            : List<About?>.from(
                json["collection"]!.map((x) => About.fromJson(x))),
        about: json["about"] == null
            ? []
            : List<About?>.from(json["about"]!.map((x) => About.fromJson(x))),
        author: json["author"] == null
            ? []
            : List<ReplyElement?>.from(
                json["author"]!.map((x) => ReplyElement.fromJson(x))),
        replies: json["replies"] == null
            ? []
            : List<ReplyElement?>.from(
                json["replies"]!.map((x) => ReplyElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? []
            : List<dynamic>.from(self!.map((x) => x!.toJson())),
        "collection": collection == null
            ? []
            : List<dynamic>.from(collection!.map((x) => x!.toJson())),
        "about": about == null
            ? []
            : List<dynamic>.from(about!.map((x) => x!.toJson())),
        "author": author == null
            ? []
            : List<dynamic>.from(author!.map((x) => x!.toJson())),
        "replies": replies == null
            ? []
            : List<dynamic>.from(replies!.map((x) => x!.toJson())),
      };
}

class ReplyElement {
  ReplyElement({
    required this.embeddable,
    required this.href,
  });

  final bool? embeddable;
  final String? href;

  factory ReplyElement.fromJson(Map<String, dynamic> json) => ReplyElement(
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "embeddable": embeddable,
        "href": href,
      };
}

class MediaDetails {
  MediaDetails({
    required this.width,
    required this.height,
    required this.file,
    required this.filesize,
    required this.sizes,
    required this.imageMeta,
  });

  final int? width;
  final int? height;
  final String? file;
  final int? filesize;
  final Map<String, PostSize?>? sizes;
  final ImageMeta? imageMeta;

  factory MediaDetails.fromJson(Map<String, dynamic> json) => MediaDetails(
        width: json["width"],
        height: json["height"],
        file: json["file"],
        filesize: json["filesize"],
        sizes: Map.from(json["sizes"]!)
            .map((k, v) => MapEntry<String, PostSize?>(k, PostSize.fromJson(v))),
        imageMeta: ImageMeta.fromJson(json["image_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "file": file,
        "filesize": filesize,
        "sizes": Map.from(sizes!)
            .map((k, v) => MapEntry<String, dynamic>(k, v!.toJson())),
        "image_meta": imageMeta!.toJson(),
      };
}

class ImageMeta {
  ImageMeta({
    required this.aperture,
    required this.credit,
    required this.camera,
    required this.caption,
    required this.createdTimestamp,
    required this.copyright,
    required this.focalLength,
    required this.iso,
    required this.shutterSpeed,
    required this.title,
    required this.orientation,
    required this.keywords,
  });

  final String? aperture;
  final String? credit;
  final String? camera;
  final String? caption;
  final String? createdTimestamp;
  final String? copyright;
  final String? focalLength;
  final String? iso;
  final String? shutterSpeed;
  final String? title;
  final String? orientation;
  final List<dynamic>? keywords;

  factory ImageMeta.fromJson(Map<String, dynamic> json) => ImageMeta(
        aperture: json["aperture"],
        credit: json["credit"],
        camera: json["camera"],
        caption: json["caption"],
        createdTimestamp: json["created_timestamp"],
        copyright: json["copyright"],
        focalLength: json["focal_length"],
        iso: json["iso"],
        shutterSpeed: json["shutter_speed"],
        title: json["title"],
        orientation: json["orientation"],
        keywords: json["keywords"] == null
            ? []
            : List<dynamic>.from(json["keywords"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "aperture": aperture,
        "credit": credit,
        "camera": camera,
        "caption": caption,
        "created_timestamp": createdTimestamp,
        "copyright": copyright,
        "focal_length": focalLength,
        "iso": iso,
        "shutter_speed": shutterSpeed,
        "title": title,
        "orientation": orientation,
        "keywords":
            keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
      };
}

class PostSize {
  PostSize({
    required this.file,
    required this.width,
    required this.height,
    required this.filesize,
    required this.mimeType,
    required this.sourceUrl,
    required this.uncropped,
  });

  final String? file;
  final int? width;
  final int? height;
  final int? filesize;
  final MimeType? mimeType;
  final String? sourceUrl;
  final bool? uncropped;

  factory PostSize.fromJson(Map<String, dynamic> json) => PostSize(
        file: json["file"],
        width: json["width"],
        height: json["height"],
        filesize: json["filesize"],
        mimeType: mimeTypeValues.map[json["mime_type"]],
        sourceUrl: json["source_url"],
        uncropped: json["uncropped"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
        "width": width,
        "height": height,
        "filesize": filesize,
        "mime_type": mimeTypeValues.reverse![mimeType],
        "source_url": sourceUrl,
        "uncropped": uncropped,
      };
}

enum MimeType { IMAGE_JPEG }

final mimeTypeValues = EnumValues({"image/jpeg": MimeType.IMAGE_JPEG});

class EmbeddedWpTerm {
  EmbeddedWpTerm({
    required this.id,
    required this.link,
    required this.name,
    required this.slug,
    required this.taxonomy,
    required this.links,
  });

  final int? id;
  final String? link;
  final String? name;
  final String? slug;
  final String? taxonomy;
  final WpTermLinks? links;

  factory EmbeddedWpTerm.fromJson(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json["id"],
        link: json["link"],
        name: json["name"],
        slug: json["slug"],
        taxonomy: json["taxonomy"],
        links: WpTermLinks.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "name": name,
        "slug": slug,
        "taxonomy": taxonomy,
        "_links": links!.toJson(),
      };
}

class WpTermLinks {
  WpTermLinks({
    required this.self,
    required this.collection,
    required this.about,
    required this.wpPostType,
    required this.curies,
  });

  final List<About?>? self;
  final List<About?>? collection;
  final List<About?>? about;
  final List<About?>? wpPostType;
  final List<Cury?>? curies;

  factory WpTermLinks.fromJson(Map<String, dynamic> json) => WpTermLinks(
        self: json["self"] == null
            ? []
            : List<About?>.from(json["self"]!.map((x) => About.fromJson(x))),
        collection: json["collection"] == null
            ? []
            : List<About?>.from(
                json["collection"]!.map((x) => About.fromJson(x))),
        about: json["about"] == null
            ? []
            : List<About?>.from(json["about"]!.map((x) => About.fromJson(x))),
        wpPostType: json["wp:post_type"] == null
            ? []
            : List<About?>.from(
                json["wp:post_type"]!.map((x) => About.fromJson(x))),
        curies: json["curies"] == null
            ? []
            : List<Cury?>.from(json["curies"]!.map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? []
            : List<dynamic>.from(self!.map((x) => x!.toJson())),
        "collection": collection == null
            ? []
            : List<dynamic>.from(collection!.map((x) => x!.toJson())),
        "about": about == null
            ? []
            : List<dynamic>.from(about!.map((x) => x!.toJson())),
        "wp:post_type": wpPostType == null
            ? []
            : List<dynamic>.from(wpPostType!.map((x) => x!.toJson())),
        "curies": curies == null
            ? []
            : List<dynamic>.from(curies!.map((x) => x!.toJson())),
      };
}

class Cury {
  Cury({
    required this.name,
    required this.href,
    required this.templated,
  });

  final String? name;
  final String? href;
  final bool? templated;

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
        name: json["name"],
        href: json["href"],
        templated: json["templated"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "href": href,
        "templated": templated,
      };
}

class PostLinks {
  PostLinks({
    required this.self,
    required this.collection,
    required this.about,
    required this.author,
    required this.replies,
    required this.versionHistory,
    required this.predecessorVersion,
    required this.wpFeaturedmedia,
    required this.wpAttachment,
    required this.wpTerm,
    required this.curies,
  });

  final List<About?>? self;
  final List<About?>? collection;
  final List<About?>? about;
  final List<ReplyElement?>? author;
  final List<ReplyElement?>? replies;
  final List<VersionHistory?>? versionHistory;
  final List<PredecessorVersion?>? predecessorVersion;
  final List<ReplyElement?>? wpFeaturedmedia;
  final List<About?>? wpAttachment;
  final List<LinksWpTerm?>? wpTerm;
  final List<Cury?>? curies;

  factory PostLinks.fromJson(Map<String, dynamic> json) => PostLinks(
        self: json["self"] == null
            ? []
            : List<About?>.from(json["self"]!.map((x) => About.fromJson(x))),
        collection: json["collection"] == null
            ? []
            : List<About?>.from(
                json["collection"]!.map((x) => About.fromJson(x))),
        about: json["about"] == null
            ? []
            : List<About?>.from(json["about"]!.map((x) => About.fromJson(x))),
        author: json["author"] == null
            ? []
            : List<ReplyElement?>.from(
                json["author"]!.map((x) => ReplyElement.fromJson(x))),
        replies: json["replies"] == null
            ? []
            : List<ReplyElement?>.from(
                json["replies"]!.map((x) => ReplyElement.fromJson(x))),
        versionHistory: json["version-history"] == null
            ? []
            : List<VersionHistory?>.from(json["version-history"]!
                .map((x) => VersionHistory.fromJson(x))),
        predecessorVersion: json["predecessor-version"] == null
            ? []
            : List<PredecessorVersion?>.from(json["predecessor-version"]!
                .map((x) => PredecessorVersion.fromJson(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? []
            : List<ReplyElement?>.from(
                json["wp:featuredmedia"]!.map((x) => ReplyElement.fromJson(x))),
        wpAttachment: json["wp:attachment"] == null
            ? []
            : List<About?>.from(
                json["wp:attachment"]!.map((x) => About.fromJson(x))),
        wpTerm: json["wp:term"] == null
            ? []
            : List<LinksWpTerm?>.from(
                json["wp:term"]!.map((x) => LinksWpTerm.fromJson(x))),
        curies: json["curies"] == null
            ? []
            : List<Cury?>.from(json["curies"]!.map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self == null
            ? []
            : List<dynamic>.from(self!.map((x) => x!.toJson())),
        "collection": collection == null
            ? []
            : List<dynamic>.from(collection!.map((x) => x!.toJson())),
        "about": about == null
            ? []
            : List<dynamic>.from(about!.map((x) => x!.toJson())),
        "author": author == null
            ? []
            : List<dynamic>.from(author!.map((x) => x!.toJson())),
        "replies": replies == null
            ? []
            : List<dynamic>.from(replies!.map((x) => x!.toJson())),
        "version-history": versionHistory == null
            ? []
            : List<dynamic>.from(versionHistory!.map((x) => x!.toJson())),
        "predecessor-version": predecessorVersion == null
            ? []
            : List<dynamic>.from(predecessorVersion!.map((x) => x!.toJson())),
        "wp:featuredmedia": wpFeaturedmedia == null
            ? []
            : List<dynamic>.from(wpFeaturedmedia!.map((x) => x!.toJson())),
        "wp:attachment": wpAttachment == null
            ? []
            : List<dynamic>.from(wpAttachment!.map((x) => x!.toJson())),
        "wp:term": wpTerm == null
            ? []
            : List<dynamic>.from(wpTerm!.map((x) => x!.toJson())),
        "curies": curies == null
            ? []
            : List<dynamic>.from(curies!.map((x) => x!.toJson())),
      };
}

class PredecessorVersion {
  PredecessorVersion({
    required this.id,
    required this.href,
  });

  final int? id;
  final String? href;

  factory PredecessorVersion.fromJson(Map<String, dynamic> json) =>
      PredecessorVersion(
        id: json["id"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "href": href,
      };
}

class VersionHistory {
  VersionHistory({
    required this.count,
    required this.href,
  });

  final int? count;
  final String? href;

  factory VersionHistory.fromJson(Map<String, dynamic> json) => VersionHistory(
        count: json["count"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "href": href,
      };
}

class LinksWpTerm {
  LinksWpTerm({
    required this.taxonomy,
    required this.embeddable,
    required this.href,
  });

  final String? taxonomy;
  final bool? embeddable;
  final String? href;

  factory LinksWpTerm.fromJson(Map<String, dynamic> json) => LinksWpTerm(
        taxonomy: json["taxonomy"],
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "taxonomy": taxonomy,
        "embeddable": embeddable,
        "href": href,
      };
}

class Meta {
  Meta({
    required this.siteSidebarLayout,
    required this.siteContentLayout,
    required this.astGlobalHeaderDisplay,
    required this.astMainHeaderDisplay,
    required this.astHfbAboveHeaderDisplay,
    required this.astHfbBelowHeaderDisplay,
    required this.astHfbMobileHeaderDisplay,
    required this.sitePostTitle,
    required this.astBreadcrumbsContent,
    required this.astFeaturedImg,
    required this.footerSmlLayout,
    required this.themeTransparentHeaderMeta,
    required this.advHeaderIdMeta,
    required this.stickHeaderMeta,
    required this.headerAboveStickMeta,
    required this.headerMainStickMeta,
    required this.headerBelowStickMeta,
  });

  final String? siteSidebarLayout;
  final String? siteContentLayout;
  final String? astGlobalHeaderDisplay;
  final String? astMainHeaderDisplay;
  final String? astHfbAboveHeaderDisplay;
  final String? astHfbBelowHeaderDisplay;
  final String? astHfbMobileHeaderDisplay;
  final String? sitePostTitle;
  final String? astBreadcrumbsContent;
  final String? astFeaturedImg;
  final String? footerSmlLayout;
  final String? themeTransparentHeaderMeta;
  final String? advHeaderIdMeta;
  final String? stickHeaderMeta;
  final String? headerAboveStickMeta;
  final String? headerMainStickMeta;
  final String? headerBelowStickMeta;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        siteSidebarLayout: json["site-sidebar-layout"],
        siteContentLayout: json["site-content-layout"],
        astGlobalHeaderDisplay: json["ast-global-header-display"],
        astMainHeaderDisplay: json["ast-main-header-display"],
        astHfbAboveHeaderDisplay: json["ast-hfb-above-header-display"],
        astHfbBelowHeaderDisplay: json["ast-hfb-below-header-display"],
        astHfbMobileHeaderDisplay: json["ast-hfb-mobile-header-display"],
        sitePostTitle: json["site-post-title"],
        astBreadcrumbsContent: json["ast-breadcrumbs-content"],
        astFeaturedImg: json["ast-featured-img"],
        footerSmlLayout: json["footer-sml-layout"],
        themeTransparentHeaderMeta: json["theme-transparent-header-meta"],
        advHeaderIdMeta: json["adv-header-id-meta"],
        stickHeaderMeta: json["stick-header-meta"],
        headerAboveStickMeta: json["header-above-stick-meta"],
        headerMainStickMeta: json["header-main-stick-meta"],
        headerBelowStickMeta: json["header-below-stick-meta"],
      );

  Map<String, dynamic> toJson() => {
        "site-sidebar-layout": siteSidebarLayout,
        "site-content-layout": siteContentLayout,
        "ast-global-header-display": astGlobalHeaderDisplay,
        "ast-main-header-display": astMainHeaderDisplay,
        "ast-hfb-above-header-display": astHfbAboveHeaderDisplay,
        "ast-hfb-below-header-display": astHfbBelowHeaderDisplay,
        "ast-hfb-mobile-header-display": astHfbMobileHeaderDisplay,
        "site-post-title": sitePostTitle,
        "ast-breadcrumbs-content": astBreadcrumbsContent,
        "ast-featured-img": astFeaturedImg,
        "footer-sml-layout": footerSmlLayout,
        "theme-transparent-header-meta": themeTransparentHeaderMeta,
        "adv-header-id-meta": advHeaderIdMeta,
        "stick-header-meta": stickHeaderMeta,
        "header-above-stick-meta": headerAboveStickMeta,
        "header-main-stick-meta": headerMainStickMeta,
        "header-below-stick-meta": headerBelowStickMeta,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
