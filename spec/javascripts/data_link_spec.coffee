describe 'Data links tests', ->

  beforeEach ->
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-links.html'

  afterEach ->
    player = null
    $.removeData document.body, 'FoundationPlayers'

  it 'has default options', ->
    $('.links').foundationPlayer()
    player = $('.links').data('FoundationPlayer')
    expect(player.options.useSeekData).toBe false
    expect(player.options.seekDataClass).toBe 'seek-to'

  it 'works with non-default options', ->
    $('.links').foundationPlayer(useSeekData: true, seekDataClass: 'time-to-go')
    player = $('.links').data('FoundationPlayer')
    expect(player.options.useSeekData).not.toBe false
    expect(player.options.useSeekData).toBe true
    expect(player.options.seekDataClass).not.toBe 'seek-to'
    expect(player.options.seekDataClass).toBe 'time-to-go'

  it 'make parseDataLinks call if necessary', ->
    spyOn FoundationPlayer.prototype, 'parseDataLinks'
    $('.links').foundationPlayer(useSeekData: true)
    expect(FoundationPlayer.prototype.parseDataLinks).toHaveBeenCalledWith()

  it 'skip parseDataLinks call by default', ->
    spyOn FoundationPlayer.prototype, 'parseDataLinks'
    $('.links').foundationPlayer()
    expect(FoundationPlayer.prototype.parseDataLinks).not.toHaveBeenCalledWith()

  # TODO: Profile jQuery selector speed [data] vs .class[data]
  # http://jsfiddle.net/cse_tushar/NT7jf/
  # http://stackoverflow.com/questions/2487747/
