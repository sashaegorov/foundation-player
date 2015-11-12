describe 'CoffeeScript suite', ->
  beforeEach ->
    jasmine.getFixtures().load 'player.html'
    $('.no-1').foundationPlayer()
    player = $('.no-1').data 'FoundationPlayer'

  it 'Initializes player', ->
    expect(player).toBeDefined()
    return

  # TODO: Delete me
  it 'It has CoffeeScript support:)', ->
    expect(true).toBe true
    expect(true).not.toBe false
    return
