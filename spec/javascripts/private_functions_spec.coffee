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

  it 'stringPadLeft() adds additional 00', ->
    minutes = 5
    expect(obj.stringPadLeft(minutes, '0', 3)).toBe '005'

  it 'prettyTime(100) returns 01:40 ', ->
    expect(obj.prettyTime(10)).toBe  '00:10'
    expect(obj.prettyTime(0)).toBe '00:00'
    expect(obj.prettyTime(1000)).toBe '16:40'
