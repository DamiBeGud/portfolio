function setupAdminMessageModal() {
  if (document.documentElement.dataset.messageModalReady === "true") return;
  document.documentElement.dataset.messageModalReady = "true";

  function modalElement() {
    return document.querySelector("[data-message-modal]");
  }

  function openModal() {
    const modal = modalElement();
    if (!modal) return;

    modal.hidden = false;
    document.body.classList.add("admin-modal-open");
    modal.querySelector("[data-message-modal-close]")?.focus();
  }

  function closeModal() {
    const modal = modalElement();
    if (!modal) return;

    modal.hidden = true;
    document.body.classList.remove("admin-modal-open");

    const frame = document.querySelector("#message-detail");
    if (frame) frame.innerHTML = "";
  }

  document.addEventListener("turbo:frame-load", (event) => {
    if (event.target.id === "message-detail") openModal();
  });

  document.addEventListener("click", (event) => {
    if (event.target.closest("[data-message-modal-close]")) {
      closeModal();
      return;
    }

    if (event.target === modalElement()) {
      closeModal();
      return;
    }

    const row = event.target.closest("[data-message-row]");
    if (row && !event.target.closest("a")) {
      const link = row.querySelector("a[data-turbo-frame='message-detail']");
      if (link) link.click();
    }
  });

  document.addEventListener("keydown", (event) => {
    const modal = modalElement();
    if (event.key === "Escape" && modal && !modal.hidden) closeModal();
  });
}

document.addEventListener("turbo:load", setupAdminMessageModal);
