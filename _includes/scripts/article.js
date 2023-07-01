(function () {
  var SOURCES = window.TEXT_VARIABLES.sources;
  window.Lazyload.js(SOURCES.jquery, function () {
    $(function () {
      var $this, $scroll;
      var $articleContent = $('.js-article-content');
      var hasSidebar = $('.js-page-root').hasClass('layout--page--sidebar');
      var scroll = hasSidebar ? '.js-page-main' : 'html, body';
      $scroll = $(scroll);

      $articleContent.find('.highlight').each(function () {
        $this = $(this);
        let $code = $this.find('code')
        console.log('22222', $code)
        // $code.append($('<button class="Clipboard_btn" data-clipboard-target=".highlight">复制/Copy</button>'));
        // new ClipboardJS('.Clipboard_btn')
        // if ($code.find('.Clipboard_btn').length == 0) {
        $code.append($('<button class="Clipboard_btn" data-clipboard-target=".highlight">复制/Copy</button>'));
        new ClipboardJS('.Clipboard_btn')
        // }
        $this.attr('data-lang', $this.find('code').attr('data-lang'));
      });
      // $articleContent.find('code').each(function () {

      //   $this = $(this);
      //   console.log('调试=====', $this.find('.Clipboard_btn').length)
      //   $this.append($('<button class="Clipboard_btn" data-clipboard-target=".highlight">复制/Copy</button>'));
      //   new clipboardJS('.Clipboard_btn')
      // });
      $articleContent.find('h1[id], h2[id], h3[id], h4[id], h5[id], h6[id]').each(function () {
        $this = $(this);
        $this.append($('<a class="anchor d-print-none" aria-hidden="true"></a>').html('<i class="fas fa-anchor"></i>'));
      });
      $articleContent.on('click', '.anchor', function () {
        $scroll.scrollToAnchor('#' + $(this).parent().attr('id'), 400);
      });
    });
  });
})();
