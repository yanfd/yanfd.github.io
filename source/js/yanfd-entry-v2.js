(function () {
  'use strict';

  var isHome = window.location.pathname === '/' || window.location.pathname === '/index.html';
  if (!isHome || !document.getElementById('banner')) return;
  if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  if (window.sessionStorage && sessionStorage.getItem('yanfd-entry-seen') === '1') return;

  var loader = document.createElement('div');
  loader.className = 'yanfd-entry-loader';
  loader.setAttribute('aria-label', 'Loading YANFD');
  loader.innerHTML = [
    '<div class="yanfd-entry-grain" aria-hidden="true"></div>',
    '<div class="yanfd-entry-topline"><span>YANFD / HEXO</span><span>SHANGHAI · CN</span></div>',
    '<div class="yanfd-entry-center">',
    '  <div class="yanfd-entry-mark"><span class="yanfd-entry-mark-f"></span><span class="yanfd-entry-mark-d"></span></div>',
    '  <p class="yanfd-entry-wordmark">YANFD</p>',
    '  <p class="yanfd-entry-caption">DIGITAL STUDIO / PERSONAL ARCHIVE</p>',
    '</div>',
    '<div class="yanfd-entry-bottom">',
    '  <div class="yanfd-entry-status"><span>INITIALIZING ARCHIVE</span><span class="yanfd-entry-counter">00 / 01</span></div>',
    '  <div class="yanfd-entry-track"><span></span></div>',
    '</div>'
  ].join('');

  document.body.appendChild(loader);
  document.documentElement.classList.add('yanfd-entry-active');

  var track = loader.querySelector('.yanfd-entry-track span');
  var counter = loader.querySelector('.yanfd-entry-counter');
  var video = document.querySelector('video');
  var minimumTime = window.setTimeout(function () {
    track.style.transform = 'scaleX(.68)';
    counter.textContent = '01 / 01';
  }, 180);

  var finish = function () {
    window.clearTimeout(minimumTime);
    track.style.transform = 'scaleX(1)';
    counter.textContent = '01 / 01';
    loader.classList.add('is-ready');

    window.setTimeout(function () {
      loader.classList.add('is-leaving');
      document.documentElement.classList.remove('yanfd-entry-active');
      if (window.sessionStorage) sessionStorage.setItem('yanfd-entry-seen', '1');
    }, 520);

    window.setTimeout(function () {
      loader.remove();
    }, 1320);
  };

  if (video && !video.readyState) {
    video.addEventListener('canplay', finish, { once: true });
    window.setTimeout(finish, 2600);
  } else {
    window.setTimeout(finish, 1050);
  }
})();
