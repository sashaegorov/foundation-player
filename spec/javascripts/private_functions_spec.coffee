# Test Foundation Player private functions
describe 'Private functions suite', ->
  obj = {}
  beforeEach ->
    jasmine.getFixtures().load 'player.html'
    $('.foundation-player').foundationPlayer()
    obj = $('.no-1').data('FoundationPlayer').testingAPI()
  afterEach ->
    obj = {}

  it 'isNumber(x) detects correct numbers', ->
    expect(obj.isNumber(1)).toBe true
    expect(obj.isNumber(null)).not.toBe true
    expect(obj.isNumber(NaN)).not.toBe true

  it 'isNumber(x) rejects strings', ->
    expect(obj.isNumber('1')).toBe false
