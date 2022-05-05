const showGeneralMenu = () => {
  document.getElementById("general-menu").classList.toggle("show");
}

const showUserMenu = () => {
  document.getElementById("session-menu").classList.toggle("show");
}

const loadFile = (event) => {
	let img = document.getElementById('output');
  document.getElementById('add').style.display = 'none';
	img.src = URL.createObjectURL(event.target.files[0]);
  img.style.display = 'block'
};

const loadFiles = (event) => {
	let container = document.getElementById('upload');
  document.getElementById('add').style.display = 'none';
  let i = 0;
  const uploadPhotos = event.target.files;
  for (let key = 0; key < uploadPhotos['length']; key++) {
    img = '<img class="photo" id="output' + key + '"/>';
    container.innerHTML = container.innerHTML + img;
    img = document.getElementById('output' + key)
    img.src = URL.createObjectURL(uploadPhotos[key]);
    img.style.display = 'block'
  }
};

window.onclick = function(event) {
  let filter_validation =  (event.target.matches('.filter-options') || event.target.matches('.fa-bars'));
  let user_validation = (event.target.matches('.user-options') || event.target.matches('.fa-user'));
  if (!(user_validation || filter_validation)) {
    let dropdowns = document.getElementsByClassName("menu");
    let i;
    for (i = 0; i < dropdowns.length; i++) {
      let openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
