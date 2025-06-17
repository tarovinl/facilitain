import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LogoutController
 */
@WebServlet("/LogoutController")
public class LogoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogoutController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Determine redirect URL based on source parameter and user role
        String source = request.getParameter("source");
        String role = null;
        if (session != null) {
            role = (String) session.getAttribute("role");
        }

        String redirectUrl;
        if ("Respondent".equals(role) && source != null) {
            switch (source) {
                case "feedback":
                    redirectUrl = request.getContextPath() + "/loginFeedbackClient.jsp";
                    break;
                case "reports":
                    redirectUrl = request.getContextPath() + "/loginReportsClient.jsp";
                    break;
                default:
                    redirectUrl = request.getContextPath() + "/index.jsp";
                    break;
            }
        } else {
            // For non-Respondent users or when source is unknown, redirect to main login
            redirectUrl = request.getContextPath() + "/index.jsp";
        }

        // Redirect to appropriate login page
        response.sendRedirect(redirectUrl);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
