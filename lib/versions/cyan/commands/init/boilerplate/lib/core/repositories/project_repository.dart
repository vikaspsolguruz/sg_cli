import 'package:newarch/core/models/pagination_model.dart';
import 'package:newarch/core/models/project_filter_model.dart';
import 'package:newarch/core/models/project_model.dart';
import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/models/view_states/list_state_with_filter.dart';
import 'package:newarch/core/network/api/api_client.dart';
import 'package:newarch/core/network/api/api_urls.dart';

class ProjectRepository {
  ProjectRepository._();

  static Future<ResponseData<PaginationData<List<ProjectModel>>>> getProjects({
    required PaginationData paginationData,
    required ProjectFilterModel projectFilter,
  }) async {
    final queryParameters = {
      ...paginationData.toJson(),
      ...projectFilter.toJson(),
    };
    final apiData = await ApiClient.instance.get(ApiLinks.projects, queryParameters: queryParameters);
    return apiData.getPaginationData<List<ProjectModel>>(
      dataParser: (data) => (data['data'] as List).map((e) => ProjectModel.fromJson(e)).toList(),
    );
  }

  /// This is just fake method, this wont come with real project
  static Future<ResponseData<PaginationData<List<ProjectModel>>>> getProjectsFakeApi({
    required ListStateWithFilter listState,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Create 1000 dummy projects for proper pagination testing
    final allProjects = List.generate(1000, (index) {
      return ProjectModel(
        id: 'proj_${index + 1}',
        name: 'Project ${index + 1}',
        addressLine1: '${100 + index} Main Street',
        addressLine2: index % 3 == 0 ? 'Suite ${index + 1}' : null,
        city: ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Dallas', 'San Francisco', 'Miami', 'Seattle', 'Denver'][index % 10],
        state: ['NY', 'CA', 'IL', 'TX', 'AZ', 'TX', 'CA', 'FL', 'WA', 'CO'][index % 10],
        zipCode: '${10000 + (index % 9999)}',
        country: 'USA',
        progress: (index * 7) % 100,
        createdAt: DateTime.now().subtract(Duration(days: index % 365)),
      );
    });

    // Apply search filtering if search query exists
    List<ProjectModel> filteredProjects = allProjects;
    final searchQuery = listState.currentSearch?.trim().toLowerCase();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredProjects = allProjects.where((project) {
        final name = project.name?.toLowerCase() ?? '';
        final address = project.addressLine1?.toLowerCase() ?? '';
        final city = project.city?.toLowerCase() ?? '';
        final state = project.state?.toLowerCase() ?? '';

        return name.contains(searchQuery) || address.contains(searchQuery) || city.contains(searchQuery) || state.contains(searchQuery);
      }).toList();
    }

    // Simulate pagination using your unique system: internal offset = actualOffset - limit
    final currentPagination = listState.paginationData;
    final limit = currentPagination?.limit ?? 10;
    final offset = (currentPagination?.offset ?? (-limit)) + limit;

    // Use actual API offset for data slicing on filtered results
    final startIndex = offset;
    final endIndex = startIndex + limit;
    final pageData = filteredProjects.length > startIndex ? filteredProjects.sublist(startIndex, endIndex) : filteredProjects;

    final paginationData = PaginationData<List<ProjectModel>>(
      limit: limit,
      offset: offset,
      // Store for next pagination call
      total: filteredProjects.length,
      // Total of filtered results, not all projects
      list: pageData,
      search: searchQuery,
    );

    return ResponseData<PaginationData<List<ProjectModel>>>(
      isSuccess: true,
      message: 'Projects loaded successfully',
      data: paginationData,
    );
  }

  static Future<ResponseData> createProject({required ProjectModel project}) async {
    final payload = project.toJson();
    final apiData = await ApiClient.instance.post(ApiLinks.projects, body: payload);
    return apiData.getResponseData();
  }

  static Future<ResponseData<ProjectModel>> getProjectDetails({required String? projectId}) async {
    final link = "${ApiLinks.projects}/$projectId";
    final apiData = await ApiClient.instance.get(link);
    return apiData.getResponseData<ProjectModel>(
      dataParser: (data) => ProjectModel.fromJson(data['data']),
    );
  }

  /// This is just fake method, this wont come with real project
  static Future<ResponseData<ProjectModel>> getProjectDetailsFake({required String projectId}) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Create fake project details based on the provided ID
    final project = ProjectModel(
      id: projectId,
      name: 'Project ${projectId.replaceAll('proj_', '')} Details',
      addressLine1: '${100 + int.parse(projectId.replaceAll('proj_', ''))} Main Street',
      addressLine2: 'Suite ${projectId.replaceAll('proj_', '')}',
      city: ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'][int.parse(projectId.replaceAll('proj_', '')) % 5],
      state: ['NY', 'CA', 'IL', 'TX', 'AZ'][int.parse(projectId.replaceAll('proj_', '')) % 5],
      zipCode: '${10000 + (int.parse(projectId.replaceAll('proj_', '')) % 9999)}',
      country: 'USA',
      progress: (int.parse(projectId.replaceAll('proj_', '')) * 7) % 100,
      createdAt: DateTime.now().subtract(Duration(days: int.parse(projectId.replaceAll('proj_', '')) % 365)),
    );

    return ResponseData<ProjectModel>(
      isSuccess: true,
      message: 'Project details loaded successfully',
      data: project,
    );
  }
}
