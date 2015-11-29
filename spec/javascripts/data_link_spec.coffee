describe 'Data links', ->

  beforeEach ->
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-links.html'

  afterEach ->
    player = null
    $.removeData document.body, 'FoundationPlayers'

  it 'are disabled by default', ->
    spyOn FoundationPlayer.prototype, 'parseDataLinks'
    $('.links').foundationPlayer()
    player = $('.links').data 'FoundationPlayer'
    expect(player.options.useSeekData).toBe false
    expect(FoundationPlayer.prototype.parseDataLinks).not.toHaveBeenCalledWith()

  it 'have working parseDataLinks option', ->
    spyOn FoundationPlayer.prototype, 'parseDataLinks'
    $('.links').foundationPlayer useSeekData: true
    player = $('.links').data 'FoundationPlayer'
    expect(player.options.useSeekData).toBe true
    expect(FoundationPlayer.prototype.parseDataLinks).toHaveBeenCalledWith()

  it 'elements have click handler', ->
    $dataTimeLinks = $('[data-seek-to-time]')
    expect($dataTimeLinks).not.toHandle 'click'
    $('.links').foundationPlayer useSeekData: true
    expect($dataTimeLinks).toHandle 'click'

  xit 'TODO: are in correct amount', ->
    false

  xit 'TODO: produce correct seek to time actions', ->
    false

  xit 'TODO: produce correct percentage seek actions', ->
    false

  xit 'TODO: are in dataLinks property', ->
    false

  xit 'TODO: handled by latest initilized player', ->
    false
