package view;

import javax.swing.*;
import java.awt.*;
import java.util.List;
import dao.MovieDAO;
import model.Movie;

public class DashboardFrame extends JFrame {

    public DashboardFrame() {

        setTitle("Movies");
        setSize(300, 300);
        setLayout(new GridLayout(0,1));

        List<Movie> movies = MovieDAO.getAllMovies();

        for (Movie m : movies) {
            add(new JLabel(m.getTitle()));
        }

        setVisible(true);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}