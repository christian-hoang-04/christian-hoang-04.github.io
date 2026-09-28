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

      function reservePublicationHeight() {
        if (list.dataset.pagination === 'news') {
          return null;
        }

        const originalMinHeight = document.documentElement.style.minHeight;
        document.documentElement.style.minHeight = `${document.documentElement.scrollHeight}px`;
        return originalMinHeight;
      }

      function restorePublicationHeight(originalMinHeight) {
        if (originalMinHeight === null) {
          return;
        }

        let stableTimer;
        let maxTimer;
        let observer;

        function restore() {
          if (observer) {
            observer.disconnect();
          }
          window.clearTimeout(stableTimer);
          window.clearTimeout(maxTimer);
          document.documentElement.style.minHeight = originalMinHeight;
          scrollToPage();
        }

        function scheduleRestore() {
          window.clearTimeout(stableTimer);
          stableTimer = window.setTimeout(restore, 200);
        }

        if (typeof ResizeObserver === 'function') {
          observer = new ResizeObserver(scheduleRestore);
          observer.observe(list);
        }

        scheduleRestore();
        maxTimer = window.setTimeout(restore, 2000);
      }

      function scrollToPage() {
        const isNews = list.dataset.pagination === 'news';
        const newsHeading = list.previousElementSibling;
        const target = isNews && newsHeading ? newsHeading : pagination;

        if (isNews && newsHeading) {
          const targetTop = newsHeading.getBoundingClientRect().top + window.scrollY;
          const topPadding = parseFloat(window.getComputedStyle(document.body).paddingTop) || 0;
          const minimumDocumentHeight = targetTop + window.innerHeight + topPadding;
          const currentDocumentHeight = document.documentElement.scrollHeight;

          if (currentDocumentHeight < minimumDocumentHeight) {
            document.body.style.paddingBottom = `${minimumDocumentHeight - currentDocumentHeight}px`;
          }

          window.scrollTo({ top: targetTop, behavior: 'auto' });
          return;
        }

        const targetBottom = target.getBoundingClientRect().bottom + window.scrollY;
        const currentDocumentHeight = document.documentElement.scrollHeight;

        if (currentDocumentHeight < targetBottom) {
          const bottomPadding = parseFloat(window.getComputedStyle(document.body).paddingBottom) || 0;
          document.body.style.paddingBottom = `${bottomPadding + targetBottom - currentDocumentHeight}px`;
        }

        window.scrollTo({
          top: Math.max(0, targetBottom - window.innerHeight),
          behavior: 'auto'
        });
      }

      function scrollToPageAfterLayout() {
        scrollToPage();
        window.requestAnimationFrame(scrollToPage);
        window.setTimeout(scrollToPage, 100);
      }

      for (let page = 1; page <= pageCount; page += 1) {
        const button = document.createElement('button');
        button.type = 'button';
        button.textContent = String(page);
        button.setAttribute('aria-label', `${sectionName}, page ${page}`);
        button.addEventListener('click', function () {
          const originalMinHeight = reservePublicationHeight();
          showPage(page);
          scrollToPageAfterLayout();
          button.blur();
          restorePublicationHeight(originalMinHeight);
        });
        buttons.push(button);
        pagination.appendChild(button);
      }

      list.parentNode.insertBefore(pagination, list.nextSibling);
      showPage(1);
    });
  });
})();
