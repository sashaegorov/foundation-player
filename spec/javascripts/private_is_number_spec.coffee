#
describe 'Private function isNumber(x) suite', ->
  beforeEach ->
    jasmine.getFixtures().load 'player.html'
    $('.no-1').foundationPlayer()
    player = $('.no-1').data 'FoundationPlayer'

  it '(x) detects correct numbers', ->
    expect(player.testingAPI().isNumber(1)).toBe true
    expect(player.testingAPI().isNumber(null)).not.toBe true
    expect(player.testingAPI().isNumber(NaN)).not.toBe true
    return

  it 'isNumber(x) rejects strings', ->
    expect(player.testingAPI().isNumber('1')).not.toBe true
    return
