import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class CreateSupabaseTables {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://aws-0-ap-northeast-1.pooler.supabase.com:5432/postgres?sslmode=require";
        String user = "postgres.wsvgiwattiwnvspmtafs";
        String password = "Rishika@sayak1";

        System.out.println("Connecting to Supabase PostgreSQL...");
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {

            System.out.println("Connected successfully!");

            String sql = Files.readString(Paths.get("schema.sql"));

            // Split and execute statements or execute batch
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
}
