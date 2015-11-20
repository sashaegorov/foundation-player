(function() {
  (function(document, window) {
    return $(document).ready(function($) {
      $(document).foundation();
      $('.foundation-player.no-1').foundationPlayer();
      window.player = $('.foundation-player.no-1').data('FoundationPlayer');
      return $('.foundation-player-tab').on('toggled', function(event, tab) {
        if (tab.hasClass('foundation-player-normal')) {
          $('.foundation-player.no-2').foundationPlayer();
        }
        if (tab.hasClass('foundation-player-small')) {
          return $('.foundation-player.no-3').foundationPlayer({
            size: 'small'
          });
        }
      });
    });
  })(document, window);

}).call(this);
