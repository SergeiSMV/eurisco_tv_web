abstract class HiveRepository{

  // сохранить логин / пароль
  Future<void> saveAuthData(Map authData);

  // получить логин / пароль
  Future<Map> getAuthData();

}