abstract class IRepository<T> {
  Future<List<T?>> getAll();
  Future<T?> getOne(String id);
  Future<void> insert(T t);
  Future<void> insertById(String id, T t);
  Future<void> update(String id, Map<String, dynamic> t);
  Future<void> delete(String id);
  Future<int> get count;
}