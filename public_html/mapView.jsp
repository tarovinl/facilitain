<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Map View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="./resources/css/custom-fonts.css">
    </head>
    <body>
    <div class="container-fluid">
      <div class="row min-vh-100">
        <jsp:include page="sidebar.jsp"/>
        
          <div class="col-md-10">
            <img
                src="resources/images/mapUST.png" 
                alt="map"
                usemap="#mapLinks"
                style="display: block;width: 100%;"/>           
            <map name="mapLinks">
                    <!-- Rectangle link: x1, y1, x2, y2 -->
                  <area shape="rect" coords="25,61,106,106" href="./buildingDashboard?locID=20" alt="FMO">
                  <area shape="rect" alt="Central Lab" coords="24,115,108,193" href="./buildingDashboard?locID=22" />
                  <area shape="rect" alt="TARC" coords="146,92,259,155" href="./buildingDashboard?locID=11" />
                  <area shape="rect" alt="Benavidez" coords="270,155,382,287" href="./buildingDashboard?locID=8" />
                  <area shape="rect" alt="UST Hospital" coords="777,325,1033,479" href="./buildingDashboard?locID=25" />
                  <area shape="rect" alt="St. Martin De Porres" coords="780,114,907,244" href="./buildingDashboard?locID=5" />
                  <area shape="rect" alt="UST Hospital Doctors Clinic" coords="936,116,1034,313" href="./buildingDashboard?locID=24" />
                  <area shape="rect" alt="St. Raymund Penafort" coords="685,147,762,267" href="./buildingDashboard?locID=4" />
                  <area shape="rect" alt="Tan Yan Kee" coords="548,94,631,153" href="./buildingDashboard?locID=16" />
                  <area shape="rect" alt="Miguel de Benavidez Library" coords="442,194,632,275" href="./buildingDashboard?locID=13" />
                  <area shape="rect" alt="Central Seminary" coords="22,213,137,391" href="./buildingDashboard?locID=1" />
                  <!--<area shape="rect" alt="" coords="22,407,135,480" href="./buildingDashboard?locID=#" />
                  <area shape="rect" alt="" coords="151,312,256,478" href="./buildingDashboard?locID=#" />-->
                  <area shape="rect" alt="Botanical Garden" coords="270,307,379,477" href="./buildingDashboard?locID=14" />
                  <area shape="rect" alt="Main Building" coords="443,325,629,459" href="./buildingDashboard?locID=3" />
                  <area shape="rect" alt="Health Service" coords="685,383,762,482" href="./buildingDashboard?locID=31" />
                  <area shape="rect" alt="BGPOP" coords="35,546,131,647" href="./buildingDashboard?locID=21" />
                  <area shape="rect" alt="Beato Angelico" coords="29,749,133,892" href="./buildingDashboard?locID=9" />
                  <area shape="rect" alt="Grandstand" coords="153,541,378,848" href="./buildingDashboard?locID=30" />
                  <!--<area shape="rect" alt="" coords="441,561,641,838" href="./buildingDashboard?locID=#" />
                  <area shape="rect" alt="" coords="695,541,895,666" href="./buildingDashboard?locID=#" />-->
                  <area shape="rect" alt="Quadricentennial Pavilion" coords="695,732,905,857" href="./buildingDashboard?locID=18" />
                  <area shape="rect" alt="Albertus Magnus" coords="935,539,1037,682" href="./buildingDashboard?locID=7" />
                  <area shape="rect" alt="Roque Ruano" coords="935,699,1035,856" href="./buildingDashboard?locID=6" />
                  <area shape="rect" alt="Frassati" coords="693,934,905,1018" href="./buildingDashboard?locID=28" />
            </map>
          </div>
      </div>
    </div>
    
    <script>
    window.onload = () => {
    const img = document.querySelector('img[usemap="#mapLinks"]');
    const map = document.querySelector('map[name="mapLinks"]');
    const originalWidth = img.naturalWidth;

    const scaleMapAreas = () => {
        const scale = img.clientWidth / originalWidth;
        const areas = map.querySelectorAll('area');
        areas.forEach(area => {
            const coords = area.dataset.originalCoords.split(',').map(Number);
            const scaledCoords = coords.map(coord => coord * scale);
            area.coords = scaledCoords.join(',');
        });
    };

    img.addEventListener('load', scaleMapAreas);
    window.addEventListener('resize', scaleMapAreas);
};

// Example for setting original coordinates
document.querySelectorAll('area').forEach(area => {
    area.dataset.originalCoords = area.coords; // Save original coords for scaling
});

    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    </body>
</html>