/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

function filterTable(inputId, tableId, col1Index, col2Index) {
    let input = document.getElementById("searchInput");
    let filter = input.value.toLowerCase();
    let table = document.getElementById("table");
    
    if (!table || !input) return;
    
    let tr = table.getElementsByTagName("tr");

    for (let i = 1; i < tr.length; i++) {
        let td1 = tr[i].getElementsByTagName("td")[col1Index];
        let td2 = tr[i].getElementsByTagName("td")[col2Index];
                
        if (td1 || td2) {
            let txt1 = td1 ? td1.textContent : "";
            let txt2 = td2 ? td2.textContent : "";

            if (txt1.toLowerCase().indexOf(filter) > -1 ||
                txt2.toLowerCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }       
    }
}
