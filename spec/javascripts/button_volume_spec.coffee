describe 'Button volume suite', ->
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

  it 'has default classes', ->
    expect(no1.$volume).toHaveClass('fi-volume')
    expect(no1.$volume).not.toHaveClass('fi-volume-strike')

  it 'has event handlers', ->
    volumeButtonSpy = spyOnEvent(no1.$volume, 'click')
    no1.$volume.click()
    expect(no1.$volume).toHandle('click')
    expect('click').toHaveBeenTriggeredOn no1.$volume

  it 'button click changes classes', ->
    # Default classes before click
    expect(no1.$volume).toHaveClass('fi-volume')
    expect(no1.$volume).not.toHaveClass('fi-volume-strike')
    no1.$volume.click()
    expect(no1.$volume).toHaveClass('fi-volume-strike')
    expect(no1.$volume).not.toHaveClass('fi-volume')

  it 'button click changes property state', ->
    # Default class before click
    expect(no1.audio.muted).toBe false
    no1.$volume.click()
    expect(no1.audio.muted).toBe true

  it 'button click handler calls proper functions', ->
    # Set spy on handler's functions
    spyOn no1, 'toggleMute'
    spyOn no1, 'updateButtonVolume'
    no1.$volume.click()
    expect(no1.toggleMute).toHaveBeenCalledWith();
    expect(no1.updateButtonVolume).toHaveBeenCalledWith();

  it 'button click handler called', ->
    spyOn no1, 'buttonVolumeHandler'
    no1.$volume.click()
    expect(no1.buttonVolumeHandler).toHaveBeenCalledWith();
