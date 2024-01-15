// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./image_preview"

document.addEventListener('turbo:load', function() {
    var iconSelect = document.getElementById('icon-select');
    var selectedIconDiv = document.getElementById('selected-icon');

    iconSelect.addEventListener('change', function() {
    var selectedOption = this.options[this.selectedIndex];
    var selectedIcon = selectedOption.value;
    var iconElement = document.createElement('i');
    iconElement.className = 'las la-' + selectedIcon;
    
    // Clear previous content and append the new icon
    selectedIconDiv.innerHTML = '';
    selectedIconDiv.appendChild(iconElement);
    });
});

document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.getElementById('sidebar');
    const content = document.getElementById('content');
    const toggleButton = document.getElementById('toggleSidebar');
    const navbar = document.getElementById('navbar');
  
    toggleButton.addEventListener('click', function () {
      if (sidebar.style.width === '250px') {
        // Close the sidebar
        sidebar.style.width = '0';
        content.style.marginLeft = '0';
        navbar.style.background = '#3778c2';
      } else {
        // Open the sidebar
        sidebar.style.width = '250px';
        content.style.marginLeft = '250px';
        navbar.style.background = 'linear-gradient(29deg, rgb(4, 43, 93), rgb(4, 43, 93), rgb(4, 43, 93), rgb(45, 126, 185), rgb(130, 171, 204))';
      }
    });
  });
  