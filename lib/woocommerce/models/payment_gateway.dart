// To parse this JSON data, do
//
//     final wooPaymentGateway = wooPaymentGatewayFromJson(jsonString);

import 'dart:convert';

List<WooPaymentGateway> wooPaymentGatewayFromJson(String str) =>
    List<WooPaymentGateway>.from(
        json.decode(str).map((x) => WooPaymentGateway.fromJson(x)));

String wooPaymentGatewayToJson(List<WooPaymentGateway> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WooPaymentGateway {
  WooPaymentGateway({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.enabled,
    required this.methodTitle,
    required this.methodDescription,
    // required this.methodSupports,
    required this.settings,
    required this.needsSetup,
    required this.postInstallScripts,
    required this.settingsUrl,
    required this.connectionUrl,
    required this.setupHelpText,
    required this.requiredSettingsKeys,
    required this.links,
  });

  final String id;
  final dynamic title;
  final String description;
  final dynamic order;
  final bool enabled;
  final String methodTitle;
  final String methodDescription;

  // final List<MethodSupport> methodSupports;
  final dynamic settings;
  final bool needsSetup;
  final List<dynamic> postInstallScripts;
  final String settingsUrl;
  final String connectionUrl;
  final String setupHelpText;
  final List<String> requiredSettingsKeys;
  final LinksPayment links;

  factory WooPaymentGateway.fromJson(Map<String, dynamic> json) =>
      WooPaymentGateway(
        id: json["id"],
        title: json["title"],
        description: json["description"] ?? "",
        order: json["order"],
        enabled: json["enabled"],
        methodTitle: json["method_title"],
        methodDescription: json["method_description"],
        // methodSupports: List<MethodSupport>.from(json["method_supports"].map((x) => methodSupportValues.map[x]) ?? []),
        settings: json["settings"],
        needsSetup: json["needs_setup"],
        postInstallScripts:
            List<dynamic>.from(json["post_install_scripts"].map((x) => x)),
        settingsUrl: json["settings_url"],
        connectionUrl: json["connection_url"] ?? "",
        setupHelpText: json["setup_help_text"] ?? "",
        requiredSettingsKeys:
            List<String>.from(json["required_settings_keys"].map((x) => x)),
        links: LinksPayment.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "order": order,
        "enabled": enabled,
        "method_title": methodTitle,
        "method_description": methodDescription,
        // "method_supports": List<dynamic>.from(methodSupports.map((x) => methodSupportValues.reverse[x])),
        "settings": settings,
        "needs_setup": needsSetup,
        "post_install_scripts":
            List<dynamic>.from(postInstallScripts.map((x) => x)),
        "settings_url": settingsUrl,
        "connection_url": connectionUrl,
        "setup_help_text": setupHelpText,
        "required_settings_keys":
            List<dynamic>.from(requiredSettingsKeys.map((x) => x)),
        "_links": links.toJson(),
      };
}

class ModelItems {
  ModelItems({this.name, this.quantity, this.price, this.currency, this.tax});

  String? name;
  int? quantity;
  String? price;
  String? currency;
  String? tax;

  factory ModelItems.fromJson(Map<String, dynamic> json) => ModelItems(
      name: json["name"],
      quantity: json["quantity"],
      price: json["price"],
      currency: json["currency"],
      tax: json["tax"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "price": price,
        "currency": currency,
        "tax": tax
      };
}

class LinksPayment {
  LinksPayment({
    required this.self,
    required this.collection,
  });

  final List<Collection> self;
  final List<Collection> collection;

  factory LinksPayment.fromJson(Map<String, dynamic> json) => LinksPayment(
        self: List<Collection>.from(
            json["self"].map((x) => Collection.fromJson(x))),
        collection: List<Collection>.from(
            json["collection"].map((x) => Collection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
      };
}

class Collection {
  Collection({
    required this.href,
  });

  final String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

enum MethodSupport { PRODUCTS, REFUNDS, TOKENIZATION, ADD_PAYMENT_METHOD }

final methodSupportValues = EnumValues({
  "add_payment_method": MethodSupport.ADD_PAYMENT_METHOD,
  "products": MethodSupport.PRODUCTS,
  "refunds": MethodSupport.REFUNDS,
  "tokenization": MethodSupport.TOKENIZATION
});

class SettingsClass {
  SettingsClass({
    required this.title,
    required this.instructions,
    required this.enableForMethods,
    required this.enableForVirtual,
    required this.apiType,
    required this.apiKey,
    required this.secretKey,
    required this.formClass,
    required this.paymentCheckoutValue,
    required this.orderStatus,
    required this.overlayScript,
    required this.formLanguage,
    required this.affiliateNetwork,
    required this.apiCredentials,
    required this.testmode,
    required this.testPublishableKey,
    required this.testSecretKey,
    required this.publishableKey,
    required this.webhook,
    required this.testWebhookSecret,
    required this.webhookSecret,
    required this.inlineCcForm,
    required this.statementDescriptor,
    required this.shortStatementDescriptor,
    required this.capture,
    required this.paymentRequest,
    required this.paymentRequestButtonType,
    required this.paymentRequestButtonTheme,
    required this.paymentRequestButtonLocations,
    required this.paymentRequestButtonSize,
    required this.savedCards,
    required this.logging,
    required this.upeCheckoutExperienceEnabled,
    required this.expiration,
  });

  final TitleClass title;
  final TitleClass instructions;
  final TitleClass enableForMethods;
  final TitleClass enableForVirtual;
  final TitleClass apiType;
  final TitleClass apiKey;
  final TitleClass secretKey;
  final TitleClass formClass;
  final TitleClass paymentCheckoutValue;
  final TitleClass orderStatus;
  final TitleClass overlayScript;
  final TitleClass formLanguage;
  final TitleClass affiliateNetwork;
  final TitleClass apiCredentials;
  final TitleClass testmode;
  final TitleClass testPublishableKey;
  final TitleClass testSecretKey;
  final TitleClass publishableKey;
  final TitleClass webhook;
  final TitleClass testWebhookSecret;
  final TitleClass webhookSecret;
  final TitleClass inlineCcForm;
  final TitleClass statementDescriptor;
  final TitleClass shortStatementDescriptor;
  final TitleClass capture;
  final TitleClass paymentRequest;
  final TitleClass paymentRequestButtonType;
  final TitleClass paymentRequestButtonTheme;
  final PaymentRequestButtonLocations paymentRequestButtonLocations;
  final TitleClass paymentRequestButtonSize;
  final TitleClass savedCards;
  final TitleClass logging;
  final TitleClass upeCheckoutExperienceEnabled;
  final Expiration expiration;

  factory SettingsClass.fromJson(Map<String, dynamic> json) => SettingsClass(
        title: TitleClass.fromJson(json["title"]),
        instructions: TitleClass.fromJson(json["instructions"]),
        enableForMethods: TitleClass.fromJson(json["enable_for_methods"]),
        enableForVirtual: TitleClass.fromJson(json["enable_for_virtual"]),
        apiType: TitleClass.fromJson(json["api_type"]),
        apiKey: TitleClass.fromJson(json["api_key"]),
        secretKey: TitleClass.fromJson(json["secret_key"]),
        formClass: TitleClass.fromJson(json["form_class"]),
        paymentCheckoutValue:
            TitleClass.fromJson(json["payment_checkout_value"]),
        orderStatus: TitleClass.fromJson(json["order_status"]),
        overlayScript: TitleClass.fromJson(json["overlay_script"]),
        formLanguage: TitleClass.fromJson(json["form_language"]),
        affiliateNetwork: TitleClass.fromJson(json["affiliate_network"]),
        apiCredentials: TitleClass.fromJson(json["api_credentials"]),
        testmode: TitleClass.fromJson(json["testmode"]),
        testPublishableKey: TitleClass.fromJson(json["test_publishable_key"]),
        testSecretKey: TitleClass.fromJson(json["test_secret_key"]),
        publishableKey: TitleClass.fromJson(json["publishable_key"]),
        webhook: TitleClass.fromJson(json["webhook"]),
        testWebhookSecret: TitleClass.fromJson(json["test_webhook_secret"]),
        webhookSecret: TitleClass.fromJson(json["webhook_secret"]),
        inlineCcForm: TitleClass.fromJson(json["inline_cc_form"]),
        statementDescriptor: TitleClass.fromJson(json["statement_descriptor"]),
        shortStatementDescriptor:
            TitleClass.fromJson(json["short_statement_descriptor"]),
        capture: TitleClass.fromJson(json["capture"]),
        paymentRequest: TitleClass.fromJson(json["payment_request"]),
        paymentRequestButtonType:
            TitleClass.fromJson(json["payment_request_button_type"]),
        paymentRequestButtonTheme:
            TitleClass.fromJson(json["payment_request_button_theme"]),
        paymentRequestButtonLocations: PaymentRequestButtonLocations.fromJson(
            json["payment_request_button_locations"]),
        paymentRequestButtonSize:
            TitleClass.fromJson(json["payment_request_button_size"]),
        savedCards: TitleClass.fromJson(json["saved_cards"]),
        logging: TitleClass.fromJson(json["logging"]),
        upeCheckoutExperienceEnabled:
            TitleClass.fromJson(json["upe_checkout_experience_enabled"]),
        expiration: Expiration.fromJson(json["expiration"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "instructions": instructions.toJson(),
        "enable_for_methods": enableForMethods.toJson(),
        "enable_for_virtual": enableForVirtual.toJson(),
        "api_type": apiType.toJson(),
        "api_key": apiKey.toJson(),
        "secret_key": secretKey.toJson(),
        "form_class": formClass.toJson(),
        "payment_checkout_value": paymentCheckoutValue.toJson(),
        "order_status": orderStatus.toJson(),
        "overlay_script": overlayScript.toJson(),
        "form_language": formLanguage.toJson(),
        "affiliate_network": affiliateNetwork.toJson(),
        "api_credentials": apiCredentials.toJson(),
        "testmode": testmode.toJson(),
        "test_publishable_key": testPublishableKey.toJson(),
        "test_secret_key": testSecretKey.toJson(),
        "publishable_key": publishableKey.toJson(),
        "webhook": webhook.toJson(),
        "test_webhook_secret": testWebhookSecret.toJson(),
        "webhook_secret": webhookSecret.toJson(),
        "inline_cc_form": inlineCcForm.toJson(),
        "statement_descriptor": statementDescriptor.toJson(),
        "short_statement_descriptor": shortStatementDescriptor.toJson(),
        "capture": capture.toJson(),
        "payment_request": paymentRequest.toJson(),
        "payment_request_button_type": paymentRequestButtonType.toJson(),
        "payment_request_button_theme": paymentRequestButtonTheme.toJson(),
        "payment_request_button_locations":
            paymentRequestButtonLocations.toJson(),
        "payment_request_button_size": paymentRequestButtonSize.toJson(),
        "saved_cards": savedCards.toJson(),
        "logging": logging.toJson(),
        "upe_checkout_experience_enabled":
            upeCheckoutExperienceEnabled.toJson(),
        "expiration": expiration.toJson(),
      };
}

class TitleClass {
  TitleClass({
    required this.id,
    required this.label,
    required this.description,
    required this.type,
    required this.value,
    required this.titleDefault,
    required this.tip,
    required this.placeholder,
    required this.options,
  });

  final String id;
  final String label;
  final String description;
  final String type;
  final String value;
  final String titleDefault;
  final String tip;
  final String placeholder;
  final TitleOptions options;

  factory TitleClass.fromJson(Map<String, dynamic> json) => TitleClass(
        id: json["id"],
        label: json["label"],
        description: json["description"],
        type: json["type"],
        value: json["value"],
        titleDefault: json["default"],
        tip: json["tip"],
        placeholder: json["placeholder"],
        options: TitleOptions.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "description": description,
        "type": type,
        "value": value,
        "default": titleDefault,
        "tip": tip,
        "placeholder": placeholder,
        "options": options.toJson(),
      };
}

class TitleOptions {
  TitleOptions({
    required this.httpsApiIyzipayCom,
    required this.httpsSandboxApiIyzipayCom,
    required this.flatRate,
    required this.freeShipping,
    required this.localPickup,
    required this.responsive,
    required this.popup,
    required this.empty,
    required this.tr,
    required this.en,
    required this.optionsDefault,
    required this.pending,
    required this.processing,
    required this.onHold,
    required this.completed,
    required this.cancelled,
    required this.refunded,
    required this.failed,
    required this.bottomLeft,
    required this.bottomRight,
    required this.hide,
    required this.medium,
    required this.large,
    required this.dark,
    required this.light,
    required this.lightOutline,
    required this.buy,
    required this.donate,
    required this.book,
  });

  final String httpsApiIyzipayCom;
  final String httpsSandboxApiIyzipayCom;
  final FlatRate flatRate;
  final FreeShipping freeShipping;
  final LocalPickup localPickup;
  final String responsive;
  final String popup;
  final String empty;
  final String tr;
  final String en;
  final String optionsDefault;
  final String pending;
  final String processing;
  final String onHold;
  final String completed;
  final String cancelled;
  final String refunded;
  final String failed;
  final String bottomLeft;
  final String bottomRight;
  final String hide;
  final String medium;
  final String large;
  final String dark;
  final String light;
  final String lightOutline;
  final String buy;
  final String donate;
  final String book;

  factory TitleOptions.fromJson(Map<String, dynamic> json) => TitleOptions(
        httpsApiIyzipayCom: json["https://api.iyzipay.com"],
        httpsSandboxApiIyzipayCom: json["https://sandbox-api.iyzipay.com"],
        flatRate: FlatRate.fromJson(json["Flat rate"]),
        freeShipping: FreeShipping.fromJson(json["Free shipping"]),
        localPickup: LocalPickup.fromJson(json["Local pickup"]),
        responsive: json["responsive"],
        popup: json["popup"],
        empty: json[""],
        tr: json["TR"],
        en: json["EN"],
        optionsDefault: json["default"],
        pending: json["pending"],
        processing: json["processing"],
        onHold: json["on-hold"],
        completed: json["completed"],
        cancelled: json["cancelled"],
        refunded: json["refunded"],
        failed: json["failed"],
        bottomLeft: json["bottomLeft"],
        bottomRight: json["bottomRight"],
        hide: json["hide"],
        medium: json["medium"],
        large: json["large"],
        dark: json["dark"],
        light: json["light"],
        lightOutline: json["light-outline"],
        buy: json["buy"],
        donate: json["donate"],
        book: json["book"],
      );

  Map<String, dynamic> toJson() => {
        "https://api.iyzipay.com": httpsApiIyzipayCom,
        "https://sandbox-api.iyzipay.com": httpsSandboxApiIyzipayCom,
        "Flat rate": flatRate.toJson(),
        "Free shipping": freeShipping.toJson(),
        "Local pickup": localPickup.toJson(),
        "responsive": responsive,
        "popup": popup,
        "": empty,
        "TR": tr,
        "EN": en,
        "default": optionsDefault,
        "pending": pending,
        "processing": processing,
        "on-hold": onHold,
        "completed": completed,
        "cancelled": cancelled,
        "refunded": refunded,
        "failed": failed,
        "bottomLeft": bottomLeft,
        "bottomRight": bottomRight,
        "hide": hide,
        "medium": medium,
        "large": large,
        "dark": dark,
        "light": light,
        "light-outline": lightOutline,
        "buy": buy,
        "donate": donate,
        "book": book,
      };
}

class FlatRate {
  FlatRate({
    required this.flatRate,
    required this.flatRate2,
  });

  final String flatRate;
  final String flatRate2;

  factory FlatRate.fromJson(Map<String, dynamic> json) => FlatRate(
        flatRate: json["flat_rate"],
        flatRate2: json["flat_rate:2"],
      );

  Map<String, dynamic> toJson() => {
        "flat_rate": flatRate,
        "flat_rate:2": flatRate2,
      };
}

class FreeShipping {
  FreeShipping({
    required this.freeShipping,
    required this.freeShipping1,
  });

  final String freeShipping;
  final String freeShipping1;

  factory FreeShipping.fromJson(Map<String, dynamic> json) => FreeShipping(
        freeShipping: json["free_shipping"],
        freeShipping1: json["free_shipping:1"],
      );

  Map<String, dynamic> toJson() => {
        "free_shipping": freeShipping,
        "free_shipping:1": freeShipping1,
      };
}

class LocalPickup {
  LocalPickup({
    required this.localPickup,
  });

  final String localPickup;

  factory LocalPickup.fromJson(Map<String, dynamic> json) => LocalPickup(
        localPickup: json["local_pickup"],
      );

  Map<String, dynamic> toJson() => {
        "local_pickup": localPickup,
      };
}

class Expiration {
  Expiration({
    required this.id,
    required this.label,
    required this.description,
    required this.type,
    required this.value,
    required this.expirationDefault,
    required this.tip,
    required this.placeholder,
  });

  final String id;
  final String label;
  final String description;
  final String type;
  final int value;
  final int expirationDefault;
  final String tip;
  final String placeholder;

  factory Expiration.fromJson(Map<String, dynamic> json) => Expiration(
        id: json["id"],
        label: json["label"],
        description: json["description"],
        type: json["type"],
        value: json["value"],
        expirationDefault: json["default"],
        tip: json["tip"],
        placeholder: json["placeholder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "description": description,
        "type": type,
        "value": value,
        "default": expirationDefault,
        "tip": tip,
        "placeholder": placeholder,
      };
}

class PaymentRequestButtonLocations {
  PaymentRequestButtonLocations({
    required this.id,
    required this.label,
    required this.description,
    required this.type,
    required this.value,
    required this.paymentRequestButtonLocationsDefault,
    required this.tip,
    required this.placeholder,
    required this.options,
  });

  final String id;
  final String label;
  final String description;
  final String type;
  final List<String> value;
  final List<String> paymentRequestButtonLocationsDefault;
  final String tip;
  final String placeholder;
  final PaymentRequestButtonLocationsOptions options;

  factory PaymentRequestButtonLocations.fromJson(Map<String, dynamic> json) =>
      PaymentRequestButtonLocations(
        id: json["id"],
        label: json["label"],
        description: json["description"],
        type: json["type"],
        value: List<String>.from(json["value"].map((x) => x)),
        paymentRequestButtonLocationsDefault:
            List<String>.from(json["default"].map((x) => x)),
        tip: json["tip"],
        placeholder: json["placeholder"],
        options: PaymentRequestButtonLocationsOptions.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "description": description,
        "type": type,
        "value": List<dynamic>.from(value.map((x) => x)),
        "default": List<dynamic>.from(
            paymentRequestButtonLocationsDefault.map((x) => x)),
        "tip": tip,
        "placeholder": placeholder,
        "options": options.toJson(),
      };
}

class PaymentRequestButtonLocationsOptions {
  PaymentRequestButtonLocationsOptions({
    required this.product,
    required this.cart,
    required this.checkout,
  });

  final String product;
  final String cart;
  final String checkout;

  factory PaymentRequestButtonLocationsOptions.fromJson(
          Map<String, dynamic> json) =>
      PaymentRequestButtonLocationsOptions(
        product: json["product"],
        cart: json["cart"],
        checkout: json["checkout"],
      );

  Map<String, dynamic> toJson() => {
        "product": product,
        "cart": cart,
        "checkout": checkout,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
