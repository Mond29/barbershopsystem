class MongoConfig {
  static const String dbUser = 'YOUR_DB_USERNAME';

  static const String dbPassword = 'YOUR_DB_PASSWORD';

  static const String clusterUrl = 'YOUR_CLUSTER_URL.mongodb.net';

  static const String dbName = 'gentleman_barbershop';

  static String get connectionString =>
      'mongodb+srv://$dbUser:$dbPassword@$clusterUrl/$dbName?retryWrites=true&w=majority&appName=Cluster0';
}
