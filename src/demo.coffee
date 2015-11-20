do (document, window) ->
  # Load on DOM ready
  $(document).ready ($) ->
    $(document).foundation()
    $('.foundation-player.no-1').foundationPlayer()
    window.player = $('.foundation-player.no-1').data 'FoundationPlayer'
    # Load when tab active
    $('.foundation-player-tab').on 'toggled', (event, tab) ->
      if tab.hasClass('foundation-player-normal')
        $('.foundation-player.no-2').foundationPlayer()
      if tab.hasClass 'foundation-player-small'
        $('.foundation-player.no-3').foundationPlayer size: 'small'
