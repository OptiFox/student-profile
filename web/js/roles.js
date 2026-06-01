/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.getElementById('studentId').addEventListener('change', function() {
    const selectedOption = this.options[this.selectedIndex];

    const currentRole = selectedOption.getAttribute('data-role');

    if (currentRole) {
        document.getElementById('newRole').value = currentRole;
    }
});
