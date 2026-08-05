function setupAdminConfirmModal() {
  if (document.documentElement.dataset.confirmModalReady === "true") return;

  let pendingElement = null;
  document.documentElement.dataset.confirmModalReady = "true";

  function modalElement() {
    return document.querySelector("[data-confirm-modal-dialog]");
  }

  function closeModal() {
    const modal = modalElement();
    if (!modal) return;

    modal.hidden = true;
    document.body.classList.remove("admin-modal-open");
    pendingElement = null;
  }

  function openModal(text, element) {
    const modal = modalElement();
    const message = document.querySelector("[data-confirm-modal-message]");
    const confirmButton = document.querySelector("[data-confirm-modal-confirm]");

    if (!modal || !message || !confirmButton) return;

    pendingElement = element;
    message.textContent = text;
    modal.hidden = false;
    document.body.classList.add("admin-modal-open");
    confirmButton.focus();
  }

  function submitModalAction(element) {
    if (element.dataset.confirmModalUrl) {
      const form = document.createElement("form");
      const csrfToken = document.querySelector("meta[name='csrf-token']")?.content;
      const method = element.dataset.confirmModalMethod || "post";

      form.method = "post";
      form.action = element.dataset.confirmModalUrl;
      form.style.display = "none";

      if (method.toLowerCase() !== "post") {
        const methodInput = document.createElement("input");
        methodInput.type = "hidden";
        methodInput.name = "_method";
        methodInput.value = method;
        form.appendChild(methodInput);
      }

      if (csrfToken) {
        const csrfInput = document.createElement("input");
        csrfInput.type = "hidden";
        csrfInput.name = "authenticity_token";
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);
      }

      document.body.appendChild(form);
      form.submit();
      return;
    }

    if (element instanceof HTMLFormElement) {
      element.requestSubmit();
    } else if (element.form) {
      element.form.requestSubmit(element);
    } else {
      element.click();
    }
  }

  document.addEventListener("submit", (event) => {
    const form = event.target;
    const confirmText = form.dataset.confirmModal;

    if (!confirmText || form.dataset.confirmed === "true") return;

    event.preventDefault();
    openModal(confirmText, form);
  });

  document.addEventListener("click", (event) => {
    if (event.target.closest("[data-confirm-modal-cancel]")) {
      closeModal();
      return;
    }

    if (event.target.closest("[data-confirm-modal-confirm]")) {
      if (!pendingElement) return;

      const confirmedElement = pendingElement;
      confirmedElement.dataset.confirmed = "true";

      submitModalAction(confirmedElement);

      delete confirmedElement.dataset.confirmed;
      closeModal();
      return;
    }

    if (event.target === modalElement()) {
      closeModal();
      return;
    }

    const trigger = event.target.closest("[data-confirm-modal]");
    if (!trigger) return;

    const confirmText = trigger.dataset.confirmModal;
    if (!confirmText || trigger.dataset.confirmed === "true") return;

    event.preventDefault();
    openModal(confirmText, trigger);
  });

  document.addEventListener("keydown", (event) => {
    const modal = modalElement();
    if (event.key === "Escape" && modal && !modal.hidden) closeModal();
  });
}

document.addEventListener("turbo:load", setupAdminConfirmModal);
