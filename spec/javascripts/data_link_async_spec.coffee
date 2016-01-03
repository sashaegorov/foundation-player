describe 'Data links', ->
  describe 'async test with actual audio', ->
    # These tests require loading of audio file
    # so they were moved here as separate suit.

    playerPrimary = null

    beforeAll ->
      jasmine.getFixtures().fixturesPath = '.'
      jasmine.getFixtures().preload \
        'spec/javascripts/fixtures/html/player-links.html'
      jasmine.getStyleFixtures().fixturesPath = '.'
      jasmine.getStyleFixtures().preload 'lib/css/foundation.min.css',
        'dist/foundation-player.css'

    afterAll ->
      jasmine.getFixtures().clearCache()

    beforeEach (done) ->
      jasmine.getFixtures().load \
        'spec/javascripts/fixtures/html/player-links.html'
      jasmine.getStyleFixtures().load 'lib/css/foundation.min.css',
        'dist/foundation-player.css'

      $('.links-primary').foundationPlayer useSeekData: true
      playerPrimary = $('.links-primary').data 'FoundationPlayer'
      playerPrimary.audio.muted = true # Mute audio
      done()

    afterEach (done) ->
      playerPrimary = null
      $.removeData document.body, 'FoundationPlayers'
      done()

    it 'produce correct seek to time actions', (done) ->
      spyOn playerPrimary, 'seekToTime' # desirable
      spyOn playerPrimary, 'seekPercent' # undesirable
      playerPrimary.onCanPlay ->
        $('#to01').click()
        expect(playerPrimary.seekToTime).toHaveBeenCalledWith 1
        expect(playerPrimary.seekPercent).not.toHaveBeenCalled()
        $('#to02').click()
        expect(playerPrimary.seekToTime).toHaveBeenCalledWith 2
        expect(playerPrimary.seekPercent).not.toHaveBeenCalled()
        done()

    it 'produce correct percentage seek actions', (done) ->
      spyOn playerPrimary, 'seekPercent' # desirable
      spyOn playerPrimary, 'seekToTime' # undesirable
      playerPrimary.onCanPlay ->
        $('#to25').click()
        expect(playerPrimary.seekPercent).toHaveBeenCalledWith 0.25
        expect(playerPrimary.seekToTime).not.toHaveBeenCalled()
        $('#to50').click()
        expect(playerPrimary.seekPercent).toHaveBeenCalledWith 0.5
        expect(playerPrimary.seekToTime).not.toHaveBeenCalled()
        done()

    it 'handled by latest initilized player', (done) ->
      # Initialize second player in addition to first
      # This player should handle all link events

      $('.links-secondary').foundationPlayer useSeekData: true
      playerSecondary = $('.links-secondary').data 'FoundationPlayer'
      playerSecondary.audio.muted = true

      spyOn playerPrimary, 'seekPercent'   # undesirable
      spyOn playerPrimary, 'seekToTime'    # undesirable
      spyOn playerSecondary, 'seekPercent' # desirable
      spyOn playerSecondary, 'seekToTime'  # desirable

      playerSecondary.onCanPlay ->
        # Timestamp links
        $('#to01').click()
        expect(playerSecondary.seekToTime).toHaveBeenCalledWith 1
        expect(playerPrimary.seekPercent).not.toHaveBeenCalled()
        $('#to02').click()
        expect(playerSecondary.seekToTime).toHaveBeenCalledWith 2
        expect(playerPrimary.seekPercent).not.toHaveBeenCalled()
        # Percentage links
        $('#to25').click()
        expect(playerSecondary.seekPercent).toHaveBeenCalledWith 0.25
        expect(playerPrimary.seekToTime).not.toHaveBeenCalled()
        $('#to50').click()
        expect(playerSecondary.seekPercent).toHaveBeenCalledWith 0.5
        expect(playerPrimary.seekToTime).not.toHaveBeenCalled()
        playerSecondary = null # Clean up the second player
        done() # We are finally done
