package connect;

import java.sql.*;

public class DBConnection {

	private static String username = "postgres";
	private static String password = "123123";
	private static String url = "jdbc:postgresql://localhost:5432/pnuips";

	private static Connection conn = null;

	public static Connection getConnection() throws Exception {
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(url, username, password);
		} catch (Exception e) {
			// TODO Auto-generated catch blocke.printStackTrace();
			e.printStackTrace();
		}
		return conn;
	}
}
