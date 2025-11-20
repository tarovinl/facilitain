import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LogoutController
 * Handles user logout and redirects to appropriate login page
 */
@WebServlet("/LogoutController")
public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogoutController() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        String role = null;
        String source = request.getParameter("source");
        String storedLoginSource = null;

        if (session != null) {
            role = (String) session.getAttribute("role");
            storedLoginSource = (String) session.getAttribute("loginSource");
            session.invalidate(); // Invalidate the session after getting attributes
        }

        // Use source parameter first, fallback to stored login source
        if (source == null || source.isEmpty()) {
            source = storedLoginSource;
        }

        String redirectUrl;
        
        // For Respondent users, redirect to their respective login pages based on source
        if ("Respondent".equals(role) && source != null && !source.isEmpty()) {
            switch (source.toLowerCase()) {
                case "feedback":
                    redirectUrl = request.getContextPath() + "/loginFeedbackClient.jsp";
                    break;
                case "reports":
                    redirectUrl = request.getContextPath() + "/loginReportClient.jsp";
                    break;
                default:
                    redirectUrl = request.getContextPath() + "/index.jsp";
                    break;
            }
        } else {
            // For all other users (Admin, Support, etc.), redirect to main login
            redirectUrl = request.getContextPath() + "/index.jsp";
        }

        System.out.println("[LogoutController] Role: " + role + ", Source: " + source + ", Redirect: " + redirectUrl);

        response.sendRedirect(redirectUrl);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
