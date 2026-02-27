/// A paginated list response from the API.
class PaginatedResponse<T> {
  /// Creates a [PaginatedResponse].
  const PaginatedResponse({
    required this.items,
    required this.pagination,
  });

  /// Parses a [PaginatedResponse] from JSON.
  ///
  /// The [fromJsonT] callback deserialises each item in
  /// the `items` array into a concrete [T] value.
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => fromJsonT(e as Map<String, dynamic>),
          )
          .toList(),
      pagination: PaginationMeta.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  /// The list of items for the current page.
  final List<T> items;

  /// Metadata describing the pagination state.
  final PaginationMeta pagination;

  /// Serialises this response back to JSON.
  ///
  /// The [toJsonT] callback serialises each [T] item
  /// into a JSON-compatible map.
  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T value) toJsonT,
  ) {
    return <String, dynamic>{
      'items': items.map(toJsonT).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

/// Metadata for a paginated API response.
class PaginationMeta {
  /// Creates a [PaginationMeta].
  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    this.hasNext,
    this.hasPrev,
  });

  /// Parses a [PaginationMeta] from JSON.
  factory PaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginationMeta(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      totalPages: json['totalPages'] as int,
      hasNext: json['hasNext'] as bool?,
      hasPrev: json['hasPrev'] as bool?,
    );
  }

  /// The current page number (1-indexed).
  final int page;

  /// The maximum number of items per page.
  final int limit;

  /// The total number of items across all pages.
  final int total;

  /// The total number of pages.
  final int totalPages;

  /// Whether there is a next page available.
  final bool? hasNext;

  /// Whether there is a previous page available.
  final bool? hasPrev;

  /// Serialises this metadata back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      if (hasNext != null) 'hasNext': hasNext,
      if (hasPrev != null) 'hasPrev': hasPrev,
    };
  }
}
