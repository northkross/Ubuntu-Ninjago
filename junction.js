document.querySelectorAll(".cards").forEach(link => {
  link.onclick = function(e) {
    e.preventDefault();
    const targetId = this.getAttribute("data-target");
    const modalId = "modal" + targetId.charAt(0).toUpperCase() + targetId.slice(1);
    const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = "block";
        }
  };
});

document.querySelectorAll(".close").forEach(closeBtn => {
  closeBtn.onclick = function() {
    this.closest(".modal").style.display = "none";
  };
});

window.onclick = function(event) {
  if (event.target.classList.contains("modal")) {
    event.target.style.display = "none";
  }
};

