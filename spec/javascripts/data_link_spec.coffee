describe 'Data links', ->

  beforeEach ->
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-links.html'

  afterEach ->
    player = null
    $.removeData document.body, 'FoundationPlayers'

  it 'enabled by default', ->
    spyOn FoundationPlayer.prototype, 'parseDataLinks'
    $('.links').foundationPlayer()
    player = $('.links').data('FoundationPlayer')
    expect(player.options.useSeekData).toBe true
    expect(FoundationPlayer.prototype.parseDataLinks).toHaveBeenCalledWith()

  it 'have working parseDataLinks option', ->
    spyOn FoundationPlayer.prototype, 'parseDataLinks'
    $('.links').foundationPlayer(useSeekData: false)
    player = $('.links').data('FoundationPlayer')
    expect(player.options.useSeekData).toBe false
    expect(FoundationPlayer.prototype.parseDataLinks).not.toHaveBeenCalledWith()

  it 'elements have handler', ->
    $dataLinks = $('[data-seek-to-time]')
    expect($dataLinks).not.toHandle 'click'

  xit 'produce correct amount of parsed links', ->
    false
