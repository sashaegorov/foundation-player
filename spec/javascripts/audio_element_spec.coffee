# Test suite related to audio loading
describe 'Audio element', ->
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

  it 'has default preload state', ->
    expect(no1.audio.preload).toBe 'auto'

  it 'has all handlers', ->
    $audio = $(no1.audio)
    expect($audio).toHandle 'loadstart'
    expect($audio).toHandle 'timeupdate'
    expect($audio).toHandle 'durationchange'
    expect($audio).toHandle 'progress'
    expect($audio).toHandle 'canplay'

  it 'handler `loadstart` works correctly', ->
    spyOn no1, 'updateDisabledStatus'
    spyOn no1, 'updateButtonPlay'
    expect(no1.updateButtonPlay).not.toHaveBeenCalled()
    expect(no1.updateDisabledStatus).not.toHaveBeenCalled()
    expect(no1.canPlayCurrent).toBe false
    $(no1.audio).trigger 'loadstart'
    expect(no1.updateButtonPlay).toHaveBeenCalled()
    expect(no1.updateDisabledStatus).toHaveBeenCalled()

  it 'handler `timeupdate` works correctly', ->
    spyOn no1, 'updatePlayedProgress'
    spyOn no1, 'updateTimeStatuses'
    expect(no1.updatePlayedProgress).not.toHaveBeenCalled()
    expect(no1.updateTimeStatuses).not.toHaveBeenCalled()
    $(no1.audio).trigger 'timeupdate'
    expect(no1.updatePlayedProgress).toHaveBeenCalled()
    expect(no1.updateTimeStatuses).toHaveBeenCalled()

  it 'handler `durationchange` works correctly', ->
    spyOn no1, 'updateTimeStatuses'
    expect(no1.updateTimeStatuses).not.toHaveBeenCalled()
    $(no1.audio).trigger 'durationchange'
    expect(no1.updateTimeStatuses).toHaveBeenCalled()

  it 'handler `progress` works correctly', ->
    spyOn no1, 'redrawBufferizationBars'
    spyOn no1, 'updateDisabledStatus'
    expect(no1.redrawBufferizationBars).not.toHaveBeenCalled()
    expect(no1.updateDisabledStatus).not.toHaveBeenCalled()
    $(no1.audio).trigger 'progress'
    expect(no1.redrawBufferizationBars).toHaveBeenCalled()
    expect(no1.updateDisabledStatus).toHaveBeenCalled()

  it 'handler `canplay` works correctly', ->
    spyOn no1, 'redrawBufferizationBars'
    spyOn no1, 'updateDisabledStatus'
    spyOn no1, 'updateButtonPlay'
    expect(no1.redrawBufferizationBars).not.toHaveBeenCalled()
    expect(no1.updateDisabledStatus).not.toHaveBeenCalled()
    expect(no1.updateButtonPlay).not.toHaveBeenCalled()
    $(no1.audio).trigger 'canplay'
    expect(no1.redrawBufferizationBars).toHaveBeenCalled()
    expect(no1.updateDisabledStatus).toHaveBeenCalled()
    expect(no1.updateButtonPlay).toHaveBeenCalled()

  it 'handler `canplay` condition works correctly', ->
    spyOn no1, 'play'
    no1.options.playOnLoad = false
    $(no1.audio).trigger 'canplay'
    expect(no1.play).not.toHaveBeenCalled()
    no1.options.playOnLoad = true
    $(no1.audio).trigger 'canplay'
    expect(no1.play).toHaveBeenCalled()
