// This represents the current filter state for the job list.
// Every time any filter changes, we reset to page 1 and re-fetch.
// Keeping filters in a separate class makes it easy to pass around
// and compare — did the filter actually change?
class JobsFilter {
  final String search;
  final String location;
  final double? minSalary;
  final double? maxSalary;
  final List<String> skills;

  const JobsFilter({
    this.search = '',
    this.location = '',
    this.minSalary,
    this.maxSalary,
    this.skills = const [],
  });

  // Convert to query params — matches exactly what backend expects:
  // GET /jobs?search=flutter&location=delhi&salary[min]=50000&skills=dart,flutter
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (search.isNotEmpty) params['search'] = search;
    if (location.isNotEmpty) params['location'] = location;
    if (minSalary != null) params['salary[min]'] = minSalary;
    if (maxSalary != null) params['salary[max]'] = maxSalary;
    if (skills.isNotEmpty) params['skills'] = skills.join(',');

    return params;
  }

  // Are all filters empty? Used to show/hide the "clear filters" button
  bool get isEmpty =>
      search.isEmpty &&
      location.isEmpty &&
      minSalary == null &&
      maxSalary == null &&
      skills.isEmpty;

  JobsFilter copyWith({
    String? search,
    String? location,
    double? minSalary,
    double? maxSalary,
    List<String>? skills,
    bool clearMinSalary = false,
    bool clearMaxSalary = false,
  }) {
    return JobsFilter(
      search: search ?? this.search,
      location: location ?? this.location,
      minSalary: clearMinSalary ? null : minSalary ?? this.minSalary,
      maxSalary: clearMaxSalary ? null : maxSalary ?? this.maxSalary,
      skills: skills ?? this.skills,
    );
  }

  // Equality check — important for knowing if filter actually changed
  @override
  bool operator ==(Object other) =>
      other is JobsFilter &&
      search == other.search &&
      location == other.location &&
      minSalary == other.minSalary &&
      maxSalary == other.maxSalary &&
      skills.toString() == other.skills.toString();

  @override
  int get hashCode =>
      Object.hash(search, location, minSalary, maxSalary, skills);
}
