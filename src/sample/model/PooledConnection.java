package sample.model;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.sql.DataSource;

public class PooledConnection {
    public PooledConnection() {
        super();
    }

    static DataSource ds = null;

    public static Connection getConnection() throws SQLException {
        try {
            Context ic = new InitialContext();
            // local database 
            ds = (DataSource) ic.lookup("jdbc/localDBDS"); 
        } catch (NamingException ne) {
            System.err.println(ne.getMessage());
        }
        return ds.getConnection();
    }
}
