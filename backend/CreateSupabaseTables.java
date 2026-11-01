import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class CreateSupabaseTables {

    public static void main(String[] args) {
        Map<String, String> env = loadEnvMap();

        String url = env.getOrDefault("DB_URL", "jdbc:postgresql://aws-0-ap-northeast-1.pooler.supabase.com:5432/postgres?sslmode=require");
        String user = env.getOrDefault("DB_USERNAME", "postgres.wsvgiwattiwnvspmtafs");
        String password = env.getOrDefault("DB_PASSWORD", "");

        if (password.isEmpty()) {
            System.err.println("Error: DB_PASSWORD is not set in .env or environment variables!");
            return;
        }

        System.out.println("Connecting to Supabase PostgreSQL...");
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {

            System.out.println("Connected successfully!");

            String sql = Files.readString(Paths.get("schema.sql"));

            System.out.println("Executing schema.sql...");
            stmt.execute(sql);

            System.out.println("SUCCESS! All tables created in Supabase PostgreSQL:");
            System.out.println(" - users table");
            System.out.println(" - otp_verifications table");
            System.out.println(" - user_sessions table");
            System.out.println(" - indexes & update trigger");

        } catch (Exception e) {
            System.err.println("Execution failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static Map<String, String> loadEnvMap() {
        Map<String, String> map = new HashMap<>(System.getenv());
        String[] candidates = {".env", "backend/.env", "../.env"};
        for (String path : candidates) {
            File f = new File(path);
            if (f.exists() && f.isFile()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(f))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (line.isEmpty() || line.startsWith("#")) continue;
                        int idx = line.indexOf('=');
                        if (idx > 0) {
                            String k = line.substring(0, idx).trim();
                            String v = line.substring(idx + 1).trim();
                            if ((v.startsWith("\"") && v.endsWith("\"")) ||
                                (v.startsWith("'") && v.endsWith("'"))) {
                                v = v.substring(1, v.length() - 1);
                            }
                            map.putIfAbsent(k, v);
                        }
                    }
                } catch (Exception ignored) {}
                break;
            }
        }
        return map;
    }
}
