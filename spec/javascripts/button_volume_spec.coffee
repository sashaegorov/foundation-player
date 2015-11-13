describe 'Button volume suite', ->
  no1 = null

  beforeEach ->
    # Fixtures
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-1.html'

  afterEach ->
    no1 = null
    $.removeData(document.body, 'FoundationPlayers')

  it 'has default classes', ->
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
    expect(no1.$volume).toHaveClass('fi-volume')
    expect(no1.$volume).not.toHaveClass('fi-volume-strike')

  it 'has event handlers', ->
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
    volumeButtonSpy = spyOnEvent(no1.$volume, 'click')
    no1.$volume.click()
    expect(no1.$volume).toHandle('click')
    expect('click').toHaveBeenTriggeredOn no1.$volume

  it 'button click changes class', ->
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
    # Default class before click
    expect(no1.$volume).toHaveClass('fi-volume')
    expect(no1.$volume).not.toHaveClass('fi-volume-strike')
    no1.$volume.click()
    expect(no1.$volume).toHaveClass('fi-volume-strike')
    expect(no1.$volume).not.toHaveClass('fi-volume')

  it 'button click changes state', ->
    $('.no-1').foundationPlayer()
    no1 = $('.no-1').data 'FoundationPlayer'
    # Default class before click
    expect(no1.audio.muted).toBe false
    no1.$volume.click()
    expect(no1.audio.muted).toBe true
