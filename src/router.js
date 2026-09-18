(function () {
  const allowedPages = ['about', 'research'];
  const queryPage = new URLSearchParams(window.location.search).get('page');
  const currentFile = window.location.pathname.split('/').pop() || 'index.html';

  if (queryPage && allowedPages.includes(queryPage) && (currentFile === 'index.html' || currentFile === '')) {
    window.location.replace(`${queryPage}.html`);
    return;
  }

  document.addEventListener('DOMContentLoaded', function () {
    const currentPage = currentFile.replace(/\.html$/, '') || 'about';
    document.querySelectorAll('#navmenu a').forEach(function (link) {
      const target = link.getAttribute('href').replace(/\.html$/, '');
      link.classList.toggle('active', target === currentPage);
    });
  });
})();