(function() {
  (function(document, window) {
    return $(document).ready(function($) {
      var $player, playerOffset;
      $(document).foundation();
      $('.foundation-player.no-1').foundationPlayer();
      window.player = $('.foundation-player.no-1').data('FoundationPlayer');
      playerOffset = $('.foundation-player.no-1').offset()['top'];
      $player = $('.foundation-player.no-1');
      $(window).scroll(function() {
        var scroll;
        scroll = $(document).scrollTop();
        if (scroll >= playerOffset) {
          $player.addClass('sticky');
          player.setPlayerSize('small');
        }
        if (scroll < playerOffset) {
          $player.removeClass('sticky');
          return player.setPlayerSize('normal');
        }
      });
      return $('#players').on('change.zf.tabs', function() {
        var activeTab;
        activeTab = $(this).find('.is-active a').attr('href');
        if (activeTab === '#normal') {
          $('.foundation-player.no-2').foundationPlayer();
        }
        if (activeTab === '#small') {
          return $('.foundation-player.no-3').foundationPlayer({
            size: 'small'
          });
        }
      });
    });
  })(document, window);

}).call(this);
