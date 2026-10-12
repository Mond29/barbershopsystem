class MongoConfig {
  static const String dbUser = 'janreyperalta312_db_user';

  static const String dbPassword = 'E5mRHicYb9BWsFQM';

  static const String clusterUrl = 'cluster0.e7z9ccv.mongodb.net';

  static const String dbName = 'gentleman_barbershop';

  static String get connectionString =>
      'mongodb+srv://$dbUser:$dbPassword@$clusterUrl/$dbName?retryWrites=true&w=majority&appName=Cluster0';
}
