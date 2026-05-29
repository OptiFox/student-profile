/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

const unitData = {
    "Unit Beruniform": ["Pengakap", "TKRS", "BSMM", "PPIM", "PPT"],
    "Kelab & Persatuan": ["Bahasa Melayu", "Bahasa Inggeris", "Rukun Negara", "STEM", "Komputer", "Agama Islam"],
    "Sukan & Permainan": ["Bola Sepak", "Bola Jaring", "Olahraga", "Badminton", "Sepak Takraw"]
};

function updateUnits() {
    const categorySelect = document.getElementById("category");
    const unitSelect = document.getElementById("unit");
    
    // Only run if these dropdowns actually exist on the current page
    if (!categorySelect || !unitSelect) return; 

    const selectedCategory = categorySelect.value;
    unitSelect.textContent = ""; // Clear old options
    
    if(selectedCategory && unitData[selectedCategory]) {
        unitData[selectedCategory].forEach(function(unit) {
            let option = document.createElement("option");
            option.value = unit;
            option.text = unit;
            unitSelect.appendChild(option);
        });
    }
}

// run updateUnits() function after the page loads
document.addEventListener("DOMContentLoaded", function() {
    updateUnits();
});