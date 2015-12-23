describe 'Data links', ->
  describe 'plugin behaviour', ->

    beforeEach ->
      jasmine.getFixtures().fixturesPath = '.'
      loadFixtures 'spec/javascripts/fixtures/html/player-links.html'

    afterEach ->
      player = null
      $.removeData document.body, 'FoundationPlayers'

    it 'are disabled by default', ->
      spyOn FoundationPlayer.prototype, 'parseDataLinks'
      $('.links-primary').foundationPlayer()
      player = $('.links-primary').data 'FoundationPlayer'
      expect(player.options.useSeekData).toBe false
      expect(FoundationPlayer.prototype.parseDataLinks)
        .not.toHaveBeenCalledWith()

    it 'have working parseDataLinks option', ->
      spyOn FoundationPlayer.prototype, 'parseDataLinks'
      $('.links-primary').foundationPlayer useSeekData: true
      player = $('.links-primary').data 'FoundationPlayer'
      expect(player.options.useSeekData).toBe true
      expect(FoundationPlayer.prototype.parseDataLinks)
        .toHaveBeenCalledWith()

    it 'for time have click handler if valid', ->
      $dataTimeLinksValid = $('.valid[data-seek-to-time]')
      expect($dataTimeLinksValid).not.toHandle 'click'
      $('.links-primary').foundationPlayer useSeekData: true
      expect($dataTimeLinksValid).toHandle 'click'

    it 'for time don\'t have click handler if invalid', ->
      $dataTimeLinksInvalid = $('.invalid[data-seek-to-time]')
      expect($dataTimeLinksInvalid).not.toHandle 'click'
      $('.links-primary').foundationPlayer useSeekData: true
      expect($dataTimeLinksInvalid).not.toHandle 'click'

    it 'for position have click handler if valid', ->
      $dataPosLinksValid = $('.valid[data-seek-to-percentage]')
      expect($dataPosLinksValid).not.toHandle 'click'
      $('.links-primary').foundationPlayer useSeekData: true
      expect($dataPosLinksValid).toHandle 'click'

    it 'for position don\'t have click handler if invalid', ->
      $dataPosLinksInvalid = $('.invalid[data-seek-to-percentage]')
      expect($dataPosLinksInvalid).not.toHandle 'click'
      $('.links-primary').foundationPlayer useSeekData: true
      expect($dataPosLinksInvalid).not.toHandle 'click'

    it 'are stored in object property', ->
      # This test requires full control over player behaviour
      player = null
      $.removeData document.body, 'FoundationPlayers'
      $('.links-primary').foundationPlayer useSeekData: false
      player = $('.links-primary').data 'FoundationPlayer'
      # Check it is empty
      expect(player.options.useSeekData).toBe false
      expect(player.dataLinks.length).toBe 0
      # Change state and parse data links
      player.options.useSeekData = true
      player.parseDataLinks()
      # Check it is empty
      expect(player.options.useSeekData).toBe true
      expect(player.dataLinks.length).not.toBe []
      expect(player.dataLinks.length).toBe 4
