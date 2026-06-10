import view.LoginFrame;
import dao.DBConnection;

public class Main {
    public static void main(String[] args) {

        // Test DB Connection
        DBConnection.getConnection();

        // Open GUI
        new LoginFrame();
    }
}