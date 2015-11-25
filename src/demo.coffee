do (document, window) ->
  # Load on DOM ready
  $(document).ready ($) ->
    $(document).foundation()
    $('.foundation-player.no-1').foundationPlayer()
    window.player = $('.foundation-player.no-1').data 'FoundationPlayer'

    # Scroll handler
    playerOffset = $('.foundation-player.no-1').offset()['top']
    $player = $('.foundation-player.no-1')
    $(window).scroll ->
      scroll = $(document).scrollTop()
      if scroll >= playerOffset
        $player.addClass 'sticky'
        player.setPlayerSize 'small'
      if scroll < playerOffset
        $player.removeClass 'sticky'
        player.setPlayerSize 'normal'

    # Load when tab active
    $('#players').on 'change.zf.tabs', ->
      activeTab = $(this).find('.is-active a').attr('href')
      if activeTab == '#normal'
        $('.foundation-player.no-2').foundationPlayer()
      if activeTab == '#small'
        $('.foundation-player.no-3').foundationPlayer size: 'small'
