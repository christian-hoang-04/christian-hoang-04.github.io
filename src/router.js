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

    document.querySelectorAll('[data-pagination]').forEach(function (list) {
      let items = Array.from(list.children);

      if (list.dataset.pagination === 'news') {
        items = items
          .map(function (item, index) {
            const dateMatch = item.textContent.trim().match(/^(\d{2})-(\d{4})/);
            const dateValue = dateMatch
              ? Number(dateMatch[2]) * 100 + Number(dateMatch[1])
              : Number.NEGATIVE_INFINITY;
            return { item: item, index: index, dateValue: dateValue };
          })
          .sort(function (left, right) {
            return right.dateValue - left.dateValue || left.index - right.index;
          })
          .map(function (entry) {
            return entry.item;
          });

        items.forEach(function (item) {
          list.appendChild(item);
        });
      }

      const itemsPerPage = Number(list.dataset.itemsPerPage) || 5;
      const pageCount = Math.ceil(items.length / itemsPerPage);

      if (pageCount <= 1) {
        return;
      }

      const sectionName = list.dataset.pagination || 'section';
      const pagination = document.createElement('nav');
      pagination.className = 'pagination';
      pagination.setAttribute('aria-label', `${sectionName} pages`);
      const buttons = [];

      function showPage(page) {
        items.forEach(function (item, index) {
          item.hidden = Math.floor(index / itemsPerPage) !== page - 1;
        });

        buttons.forEach(function (button, index) {
          if (index === page - 1) {
            button.setAttribute('aria-current', 'page');
          } else {
            button.removeAttribute('aria-current');
          }
        });
      }

      function scrollToPage(page) {
        const target = page === 1 ? pagination : list;
        target.scrollIntoView({
          behavior: 'smooth',
          block: page === 1 ? 'end' : 'start'
        });
      }

      for (let page = 1; page <= pageCount; page += 1) {
        const button = document.createElement('button');
        button.type = 'button';
        button.textContent = String(page);
        button.setAttribute('aria-label', `${sectionName}, page ${page}`);
        button.addEventListener('click', function () {
          showPage(page);
          scrollToPage(page);
        });
        buttons.push(button);
        pagination.appendChild(button);
      }

      list.parentNode.insertBefore(pagination, list.nextSibling);
      showPage(1);
    });
  });
})();
