const ANIMATION_STORAGE_KEY = "portfolio-animation-preference";
const THEME_STORAGE_KEY = "portfolio-theme-preference";

let cleanupPortfolio = () => {};

function setupPortfolio() {
  cleanupPortfolio();

  const body = document.body;
  const nav = document.querySelector(".primary-nav");
  const header = document.querySelector(".site-header");
  const navLinks = [...document.querySelectorAll("[data-page-link]")];
  const pages = [...document.querySelectorAll("[data-page]")];
  const revealItems = [...document.querySelectorAll(".reveal")];
  const projectStage = document.querySelector("[data-project-stage]");
  const projectCards = [...document.querySelectorAll("[data-project-card]")];
  const motionToggle = document.querySelector(".motion-toggle");
  const motionState = document.querySelector(".motion-toggle__state");
  const themeToggle = document.querySelector(".theme-toggle");
  const themeState = document.querySelector(".theme-toggle__state");

  if (!nav || !header) return;

  const abortController = new AbortController();
  const { signal } = abortController;
  const motionMq = window.matchMedia("(prefers-reduced-motion: reduce)");
  const themeMq = window.matchMedia("(prefers-color-scheme: dark)");
  let manualMotionPreference = localStorage.getItem(ANIMATION_STORAGE_KEY);
  let manualThemePreference = localStorage.getItem(THEME_STORAGE_KEY);
  let animationsEnabled = resolveAnimationPreference();
  let ticking = false;
  let scrollAnimationFrame = null;
  let savedRootScrollBehavior = null;

  function resolveAnimationPreference() {
    if (manualMotionPreference === "on") return true;
    if (manualMotionPreference === "off") return false;
    return !motionMq.matches;
  }

  function effectiveTheme() {
    if (manualThemePreference === "light" || manualThemePreference === "dark") return manualThemePreference;
    if (body.classList.contains("theme-light")) return "light";
    if (body.classList.contains("theme-dark")) return "dark";
    return themeMq.matches ? "dark" : "light";
  }

  function updateThemeUi() {
    const theme = effectiveTheme();
    body.classList.toggle("is-dark", theme === "dark");
    body.classList.toggle("is-light", theme === "light");
    if (themeState) themeState.textContent = theme === "dark" ? "Dark" : "Light";
  }

  function updateMotionUi() {
    body.classList.toggle("animations-disabled", !animationsEnabled);
    body.classList.toggle("reduced-motion", motionMq.matches && manualMotionPreference !== "on");

    if (!motionToggle || !motionState) return;

    motionToggle.setAttribute("aria-pressed", String(animationsEnabled));
    motionToggle.setAttribute("aria-label", animationsEnabled ? "Disable animations" : "Enable animations");
    motionState.textContent = animationsEnabled ? "On" : "Off";
  }

  function setDockedNav(isDocked) {
    const state = isDocked ? "docked" : "home";
    nav.dataset.navState = state;
    header.dataset.navState = state;
    body.classList.toggle("nav-docked", isDocked);
  }

  function setCurrentPage() {
    const viewportPoint = window.scrollY + window.innerHeight * 0.42;
    const currentPage = [...pages].reverse().find((page) => page.offsetTop <= viewportPoint);

    setDockedNav(Boolean(currentPage));

    navLinks.forEach((link) => {
      const isCurrent = currentPage ? link.hash === `#${currentPage.id}` : link.hash === "#home";
      if (isCurrent) {
        link.setAttribute("aria-current", "page");
      } else {
        link.removeAttribute("aria-current");
      }
    });
  }

  function updateProjectCards() {
    if (!projectStage || !projectCards.length || !animationsEnabled) {
      projectCards.forEach((card) => {
        card.style.removeProperty("--project-y");
        card.style.removeProperty("--project-rotate");
        card.style.removeProperty("--project-scale");
        card.style.removeProperty("--project-opacity");
      });
      return;
    }

    const stageRect = projectStage.getBoundingClientRect();
    const stageProgress = Math.min(
      Math.max(-stageRect.top / Math.max(projectStage.offsetHeight - window.innerHeight, 1), 0),
      1
    );

    projectCards.forEach((card, index) => {
      const cardProgress = stageProgress * (projectCards.length - 1) - index;
      const clamped = Math.min(Math.max(cardProgress, -1), 1);
      const distance = clamped * -42;
      const rotate = clamped * -3.5;
      const scale = 1 - Math.abs(clamped) * 0.045;
      const opacity = 1 - Math.max(Math.abs(clamped) - 0.72, 0) * 1.5;

      card.style.setProperty("--project-y", `${distance}px`);
      card.style.setProperty("--project-rotate", `${rotate}deg`);
      card.style.setProperty("--project-scale", scale.toFixed(3));
      card.style.setProperty("--project-opacity", opacity.toFixed(3));
      card.style.zIndex = String(projectCards.length + index);
    });
  }

  function onScroll() {
    if (ticking) return;
    ticking = true;

    requestAnimationFrame(() => {
      setCurrentPage();
      updateProjectCards();
      ticking = false;
    });
  }

  function easeOutCubic(progress) {
    return 1 - Math.pow(1 - progress, 3);
  }

  function scrollToTarget(target) {
    if (scrollAnimationFrame) {
      cancelAnimationFrame(scrollAnimationFrame);
      scrollAnimationFrame = null;
      if (savedRootScrollBehavior !== null) {
        document.documentElement.style.scrollBehavior = savedRootScrollBehavior;
        savedRootScrollBehavior = null;
      }
    }

    const startY = window.scrollY;
    const targetY = target.id === "home" ? 0 : target.offsetTop;
    const distance = targetY - startY;
    const duration = Math.min(Math.max(Math.abs(distance) * 0.55, 720), 1400);
    const startTime = performance.now();
    const root = document.documentElement;

    if (!animationsEnabled) {
      window.scrollTo({ top: targetY, behavior: "auto" });
      setCurrentPage();
      updateProjectCards();
      return;
    }

    savedRootScrollBehavior = root.style.scrollBehavior;
    root.style.scrollBehavior = "auto";

    function step(now) {
      const elapsed = now - startTime;
      const progress = Math.min(elapsed / duration, 1);

      window.scrollTo(0, startY + distance * easeOutCubic(progress));
      setCurrentPage();
      updateProjectCards();

      if (progress < 1) {
        scrollAnimationFrame = requestAnimationFrame(step);
      } else {
        scrollAnimationFrame = null;
        root.style.scrollBehavior = savedRootScrollBehavior;
        savedRootScrollBehavior = null;
      }
    }

    scrollAnimationFrame = requestAnimationFrame(step);
  }

  const pageObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) entry.target.classList.add("is-visible");
    });
  }, { threshold: 0.18 });

  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) entry.target.classList.add("is-visible");
    });
  }, { threshold: 0.24 });

  pages.forEach((page) => pageObserver.observe(page));
  revealItems.forEach((item) => revealObserver.observe(item));

  navLinks.forEach((link) => {
    link.addEventListener("click", (event) => {
      const target = document.querySelector(link.hash);
      if (!target) return;

      event.preventDefault();
      setDockedNav(link.hash !== "#home");

      requestAnimationFrame(() => {
        scrollToTarget(target);
        history.pushState(null, "", link.hash);
      });
    }, { signal });
  });

  motionToggle?.addEventListener("click", () => {
    animationsEnabled = !animationsEnabled;
    manualMotionPreference = animationsEnabled ? "on" : "off";
    localStorage.setItem(ANIMATION_STORAGE_KEY, manualMotionPreference);
    updateMotionUi();
    updateProjectCards();
  }, { signal });

  themeToggle?.addEventListener("click", () => {
    const nextTheme = effectiveTheme() === "dark" ? "light" : "dark";
    manualThemePreference = nextTheme;
    localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
    updateThemeUi();
  }, { signal });

  motionMq.addEventListener("change", () => {
    animationsEnabled = resolveAnimationPreference();
    updateMotionUi();
    updateProjectCards();
  }, { signal });

  themeMq.addEventListener("change", updateThemeUi, { signal });

  updateThemeUi();
  updateMotionUi();
  setCurrentPage();
  updateProjectCards();
  window.addEventListener("scroll", onScroll, { passive: true, signal });
  window.addEventListener("resize", onScroll, { signal });

  cleanupPortfolio = () => {
    abortController.abort();
    pageObserver.disconnect();
    revealObserver.disconnect();

    if (scrollAnimationFrame) cancelAnimationFrame(scrollAnimationFrame);
    if (savedRootScrollBehavior !== null) {
      document.documentElement.style.scrollBehavior = savedRootScrollBehavior;
    }

    cleanupPortfolio = () => {};
  };
}

document.addEventListener("turbo:load", setupPortfolio);
document.addEventListener("turbo:before-cache", cleanupPortfolio);
