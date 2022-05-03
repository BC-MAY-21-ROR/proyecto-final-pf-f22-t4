const showGeneralMenu = () => {
  document.getElementById("general-menu").classList.toggle("show");
}

const showUserMenu= () => {
  document.getElementById("session-menu").classList.toggle("show");
}

window.onclick = function(event) {
  let filter_validation =  (event.target.matches('.filter-options') || event.target.matches('.fa-bars'));
  let user_validation = (event.target.matches('.user-options') || event.target.matches('.fa-user'));
  if (!(user_validation || filter_validation)) {
    let dropdowns = document.getElementsByClassName("menu");
    let i;
    console.log(dropdowns)
    for (i = 0; i < dropdowns.length; i++) {
      let openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
