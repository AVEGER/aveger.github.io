(function () {
  var $root = document.getElementsByClassName('root')[0];
  if (window.hasEvent('touchstart')) {
    $root.dataset.isTouch = true;
    document.addEventListener('touchstart', function () { }, false);
  }
  //测试在全局引入需要的CDN库
  let body = document.getElementsByTagName('body')[0]
  let script = document.createElement('script')

  var Clipboard_CDN = 'https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.8/clipboard.min.js'
  script.setAttribute('src', Clipboard_CDN)
  $root.appendChild(script)
})();
