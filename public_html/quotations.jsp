<!DOCTYPE html>
<%@ page contentType="text/html;charset=windows-1252"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"/>
        
        <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.1/css/jquery.dataTables.min.css">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
    <!-- Bootstrap 5 CSS and JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
    </head>
    <body>
    <div class="modal fade" id="quotEquipment" tabindex="-1" role="dialog" aria-labelledby="equipmentquot" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header d-flex align-items-center justify-content-space-between">
            <h3 class="modal-title fw-bold" id="equipmentquot">Quotations</h3>
            <div>
            <label for="quotationsUpload" class="btn btn-dark text-warning fw-bold mx-3 mt-2">
                Upload Quotations
                <input type="file" id="quotationsUpload" style="display: none;">
            </label>
            <span id="modalItemId" style="display: none;"></span>
            <button type="button" class="btn btn-warning fw-bold ms-auto" data-bs-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
        </div>


            <div class="modal-body">
                <div class="centered-div bg-white">
                    <div class="container mt-2 mb-2">
                        <!-- Table Section -->
                        <div class="row mt-1">
                            <div class="col">
                                <table id="quotationsTable" class="table table-striped table-hover table-bordered">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th scope="col">Code</th>
                                            <th scope="col">Description</th>
                                            <th scope="col">Date Uploaded</th>
                                            <th scope="col"></th> <!-- Empty column for actions -->
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>001</td>
                                            <td>Sample Description 1</td>
                                            <td>2024-10-17</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>002</td>
                                            <td>Sample Description 2</td>
                                            <td>2024-10-18</td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>     
                </div>            
            </div>
        </div>
    </div>
</div>


<script>
$(document).ready(function(){
    $('#quotationsTable').DataTable({
        "paging": true,         // Enable pagination
        "pageLength": 5,        // Set the number of entries per page
        "lengthChange": false,  // Hide the option to change the number of rows displayed
        "info": false,          // Hide table information (e.g., "Showing 1 to 5 of 20 entries")
        "searching": false,     // Disable the search box
        "ordering": false       // Disable column sorting
    });
});



</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>