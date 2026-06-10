package view;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import dao.UserDAO;

public class LoginFrame extends JFrame {

    public LoginFrame() {

        setTitle("Login");
        setSize(300, 200);
        setLayout(new GridLayout(3, 2));

        JLabel emailLabel = new JLabel("Email:");
        JTextField emailField = new JTextField();

        JLabel passwordLabel = new JLabel("Password:");
        JPasswordField passwordField = new JPasswordField();

        JButton loginButton = new JButton("Login");

        // 🔥 THIS IS THE SUCCESS BLOCK (LOGIN LOGIC)
        loginButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {

                String email = emailField.getText();
                String password = new String(passwordField.getPassword());

                if (UserDAO.login(email, password)) {
                    JOptionPane.showMessageDialog(null, "Login Successful ✅");
                    new DashboardFrame(); // open next screen
                    dispose(); // close login window
                } else {
                    JOptionPane.showMessageDialog(null, "Invalid Credentials ❌");
                }
            }
        });

        add(emailLabel);
        add(emailField);
        add(passwordLabel);
        add(passwordField);
        add(loginButton);

        setVisible(true);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}