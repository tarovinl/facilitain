<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
     
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
 
    <script src="https://kit.fontawesome.com/da872a78e8.js" crossorigin="anonymous"></script>
  
    
    <style>
               

            .hover-outline {
                transition: all 0.3s ease;
                border: 1px solid transparent; /* Reserve space for border */
            }

            .hover-outline:hover {
                background-color: #1C1C1C !important;
                color: #f2f2f2 !important;
                border: 1px solid #f2f2f2 !important;
            }
            .hover-outline img {
                transition: filter 0.3s ease;
            }

            .hover-outline:hover img {
                filter: invert(1);
            }
            
            .card:focus,
            .card:active {
                 outline: none;
            }
            .hover-shadow:hover {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.4) !important;
            }
           .hover-underline-title:hover .card-title {
                 text-decoration: underline;
                     text-decoration-color: white;
                text-underline-offset: 3px; 
                }
           #notificationBadge {
                  top: -0.3em;
                  right: -0.6em;
                  position: absolute;
                  display: inline-flex;
                  align-items: center;
                  justify-content: center;
                
                  height: 1.6em;
                  min-width: 1.6em;
                  padding: 0 0.4em;
                
                  font-size: 0.75rem;
                  font-weight: 700;
                  color: white;
                  background-color: red;
                
                  border-radius: 50%;
                  line-height: 1;
                  text-align: center;
                  white-space: nowrap;
                  box-sizing: border-box;
                }

                
                 .circle-hover {
                    width: 45px;
                    height: 45px;
                    border-radius: 50%;
                    display: inline-flex !important;
                    justify-content: center;
                    align-items: center;
                    transition: background-color 0.2s ease-in-out;
                  }
                
                  .circle-hover:hover {
                    background-color: #dbe4e9 !important;
                  }
                
                  .circle-hover img {
                    pointer-events: none; /* ensures hover is on the circle, not just the image */
                  }    
            /* Responsive adjustments */
            @media (max-width: 767.98px) {
                .header-row {
                    flex-direction: column;
                    align-items: flex-start !important;
                }
                .header-title {
                    margin-bottom: 1rem;
                }
                .header-controls {
                    width: 100%;
                    justify-content: space-between;
                }
                
                body, html {
                  overflow-x: hidden !important;
                }
                #searchInput::placeholder {
                  padding-left: 0rem; /* Optional: fine-tune if needed */
                }
                .icon-btn {
                width: 22px;
                height: 22px;
              }
               .circle-hover {
                    width: 35px;
                    height: 35px;
                   
                  }
            }
                .tooltip {
          font-family: 'NeueHaasLight', sans-serif !important;
          font-size: 0.75rem; /* Optional: adjust size if needed */
        }
            .custom-dropdown {
              position: absolute;
              top: 110%; /* appear below icon */
              right: 0;
              background-color: white;
              min-width: 200px;
              z-index: 1000;
              font-family: 'NeueHaasLight', sans-serif !important;
            }
            
            .dropdown-wrapper {
              position: relative;
            }
        #userButton {
          cursor: pointer;
        }
            .logout-btn {
              transition: color 0.3s ease, background-color 0.3s ease;
            }
            
            .logout-icon {
              filter: brightness(0) saturate(100%) invert(27%) sepia(95%) saturate(4900%) hue-rotate(352deg) brightness(90%) contrast(120%);
              transition: filter 0.3s ease;
            }
            
            .logout-btn:hover {
              color: white; /* Makes text white */
              background-color: #dc3545; /* Bootstrap danger red background */
            }
            
            .logout-btn:hover .logout-icon {
              filter: brightness(0) invert(1); /* Makes icon white */
            }


                  
    </style>
    </head>
    <body>
    <div class="container-fluid">
<nav class="navbar bg-white py-3 mb-4 fixed-top border-bottom border-light-subtle" style="z-index: 1040;">
  <div class="container-fluid">
    <div class="row align-items-center flex-wrap w-100 gx-2">
      
      <!-- Logo -->
      <div class="col-4 col-md-3 order-md-1 text-start">
        <a href="<%=request.getContextPath()%>/homepage" class="p-0 d-inline-block">
          <img src="resources/images/FACILITAIN_WLOGO4.png"
               alt="Facilitain Home Logo"
               style="max-width: 100%; max-height: 50px;" />
        </a>
      </div>

      <!-- Right-side icons -->
      <div class="col-8 col-md-3 ms-auto order-md-2 text-end">
        <div class="d-flex justify-content-end align-items-center gap-1">

          <!-- Reports Icon -->
         <a href="reports" 
           class="circle-hover text-dark position-relative" 
           data-bs-toggle="tooltip" 
           data-bs-placement="bottom" 
           title="Reports">
          <img src="resources/images/icons/reportsb.svg" class="icon-btn" alt="Reports" width="28" height="28">
        </a>
        
       <a href="notification" 
           class="circle-hover text-dark position-relative" 
           data-bs-toggle="tooltip" 
           data-bs-placement="bottom" 
           title="Notifications">
          <img src="resources/images/icons/notifb.svg" class="icon-btn" alt="Notifications" width="28" height="28">
          <span id="notificationBadge" class="badge position-absolute">3</span>
        </a>

        
        <div class="dropdown-wrapper position-relative">
  <a id="userButton"
   class="circle-hover text-dark d-flex align-items-center gap-1"
   data-bs-toggle="tooltip"
   data-bs-placement="bottom"
   title="User"
   style="cursor: pointer;">
  <img src="resources/images/icons/person.svg" class="icon-btn" alt="User" width="28" height="28">
</a>


  <div id="userDropdown" class="custom-dropdown shadow p-3 rounded" style="display: none;">
    <div class="d-flex align-items-center gap-2 mb-2">
      
      <div class="d-flex flex-column text-start">
          <div class="fw-bold mb-0">Kevin Coraza</div>
          <div class="text-muted" style="font-size: 0.85rem; margin-left: 0;">
    <c:choose>
        <c:when test="${sessionScope.role == 'Admin'}">
            Admin
        </c:when>
        <c:when test="${sessionScope.role == 'Support'}">
            Staff
        </c:when>
        <c:otherwise>
            User
        </c:otherwise>
    </c:choose>
</div>
        </div>

    </div>
    <a href="<%=request.getContextPath()%>/LogoutController"
   class="btn btn-sm btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 logout-btn">
  <img src="resources/images/icons/logout.svg" alt="Logout" class="logout-icon"
       style="width: 1.2em; height: 1.2em;">
  Log Out
</a>

  </div>
</div>



        </div>
      </div>

    </div>
  </div>
</nav>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
  // Initialize all tooltips on the page
  document.addEventListener('DOMContentLoaded', function () {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
      new bootstrap.Tooltip(tooltipTriggerEl);
    });
  });
</script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const userButton = document.getElementById('userButton');
    const dropdown = document.getElementById('userDropdown');

    userButton.addEventListener('click', function (e) {
      e.stopPropagation();
      dropdown.style.display = dropdown.style.display === 'none' || dropdown.style.display === '' ? 'block' : 'none';
    });

    document.addEventListener('click', function (e) {
      if (!dropdown.contains(e.target)) {
        dropdown.style.display = 'none';
      }
    });
  });
</script>

    </body>
</html>