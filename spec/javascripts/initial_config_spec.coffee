describe 'Elements for Initialization', ->
  no1 = null
  beforeEach ->
    # Fixtures
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-1.html'
    # Setup
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'

  afterEach ->
    no1 = null
    $.removeData(document.body, 'FoundationPlayers')

  it 'Constructor defaults exists', ->
    expect(no1.canPlayCurrent).toBe false
    expect(no1.options.playOnLoad).toBe false
    expect(no1.currentUISize).toEqual no1.options.playerUISize
    expect(no1.played).toEqual 0

  it 'Initial elements found in DOM', ->
    expect(no1.$player).toHaveClass 'player'
    expect(no1.$sources).toContain 'audio'
    expect(no1.$play.length).not.toEqual 0
    expect(no1.$rewind.length).not.toEqual 0
    expect(no1.$volume.length).not.toEqual 0
    expect(no1.$elapsed.length).not.toEqual 0
    expect(no1.$remains.length).not.toEqual 0
    expect(no1.$progress.length).not.toEqual 0
    expect(no1.$played.length).not.toEqual 0
