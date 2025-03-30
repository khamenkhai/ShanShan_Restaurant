import 'package:flutter/material.dart';

@immutable
class ApiConstants {
  // Base URL for different environments
  static const String BASE_URL_DEV = "http://3.115.85.31/api";
  // static const String BASE_URL_STAGING = "https://staging-api.example.com";
  // static const String BASE_URL_PROD = "https://api.example.com";

  // Auth API paths (endpoints)
  static const String LOGIN = "${BASE_URL_DEV}/auth/login";
  static const String LOGOUT = "${BASE_URL_DEV}/auth/logout";

  // Htone Level Crud
  static const String GET_HTONE_LEVEL = "htone-level";
  static const String STORE_HTONE_LEVEL = "htone-level/store";
  static const String DELETE_HTONE_LEVEL = "htone-level/delete";
  static const String Edit_HTONE_LEVEL = "htone-level/edit";

  // Spicy Level Crud
  static const String GET_SPICY_LEVEL = "spicy-level";
  static const String STORE_SPICY_LEVEL = "spicy-level/store";
  static const String DELETE_SPICY_LEVEL = "spicy-level/delete";
  static const String EDIT_SPICY_LEVEL = "spicy-level/edit";

  // Category API paths (endpoints)
  static const String GET_CATEGORY = "category"; // Get all categories
  static const String CREATE_CATEGORY = "category/store"; // Create a category
  static const String DELETE_CATEGORY = "category/delete"; // Delete a category
  static const String EDIT_CATEGORY = "category/edit"; // Update a category

  // History API paths (endpoints)
  static const String GET_HISTORY_LIST ="sale/lists"; // Get sale histories by pagination
  static const String SEARCH_SALE_HISTORY ="sale/search"; // Search sale history by slip number
  static const String GET_SALE_HISTORY_DETAIL ="sale/detail"; // Get detailed sale history
  static const String GET_TOTAL_SALE_AND_SLIPS ="sale/total"; // Get total sales and total slip number

  // Menu API endpoints
  static const String GET_MENU_LIST = "menu";
  static const String CREATE_MENU = "menu/store";
  static const String DELETE_MENU = "menu/delete";
  static const String EDIT_MENU = "menu/edit";

  // Product API endpoints
  static const String GET_PRODUCTS = "product";
  static const String CREATE_PRODUCT = "product/store";
  static const String DELETE_PRODUCT = "product/delete";
  static const String EDIT_PRODUCT = "product/edit";
  static const String GET_PRODUCTS_BY_CATEGORY = "category/by-product";
  static const String GET_PRODUCTS_BY_PAGINATION = "product/pagination";
  static const String GET_PRODUCT_BY_BARCODE = "product/barcode";

  // Sale-Report related endpoints
  static const String DAILY_SALE_URL = "sale/daily";
  static const String WEEKLY_SALE_URL = "sale/weekly";
  static const String CURRENT_MONTH_SALE_URL = "sale/currentMonth";
  static const String PAST_MONTH_SALE_URL = "sale/pastMonth";

  // Sale-related endpoints
  static const String MAKE_SALE_URL = "sale/make";
  static const String UPDATE_SALE_URL = "sale/update";

  // Timeout settings for network calls
  static const int TIMEOUT_DURATION_IN_SECONDS = 30;
}
