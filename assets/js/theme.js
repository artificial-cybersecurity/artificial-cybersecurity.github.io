/* Theme toggle: system preference by default, explicit choice remembered. */
(function () {
  var root = document.documentElement;
  var media = window.matchMedia('(prefers-color-scheme: light)');

  function stored() {
    try { return localStorage.getItem('theme'); } catch (e) { return null; }
  }

  function apply(theme) {
    root.setAttribute('data-theme', theme);
  }

  // No explicit choice yet? Follow the operating system, and keep following it.
  if (stored() !== 'light' && stored() !== 'dark') {
    apply(media.matches ? 'light' : 'dark');
    media.addEventListener('change', function (e) {
      if (stored() !== 'light' && stored() !== 'dark') apply(e.matches ? 'light' : 'dark');
    });
  }

  var button = document.querySelector('.theme-toggle');
  if (!button) return;

  button.addEventListener('click', function () {
    var next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    apply(next);
    try { localStorage.setItem('theme', next); } catch (e) {}
  });
})();
