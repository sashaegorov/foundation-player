# Test Foundation Player private functions
describe 'Private functions suite', ->
  obj = {}
  beforeEach ->
    loadFixtures 'player.html'
    $('.no-1').foundationPlayer()
    obj = $('.no-1').data('FoundationPlayer').testingAPI()
  afterEach ->
    obj = {}
    $.removeData(document.body, 'FoundationPlayers')


  it 'isNumber() detects correct numbers', ->
    expect(obj.isNumber(1)).toBe true
    expect(obj.isNumber(42)).toBe true
    expect(obj.isNumber(null)).not.toBe true
    expect(obj.isNumber(NaN)).not.toBe true

  it 'isNumber() rejects strings', ->
    expect(obj.isNumber('1')).toBe false
    expect(obj.isNumber('42')).not.toBe true

  it 'stringPadLeft() adds additional 00', ->
    expect(obj.stringPadLeft('.', 'X', 5)).toBe 'XXXX.'
    expect(obj.stringPadLeft(5, '0', 3)).toBe '005'
    expect(obj.stringPadLeft('x', '0', 2)).toBe '0x'

  it 'prettyTime() returns formated time', ->
    expect(obj.prettyTime(0)).toBe '00:00'
    expect(obj.prettyTime(10)).toBe  '00:10'
    expect(obj.prettyTime(60)).toBe  '01:00'
    expect(obj.prettyTime(120)).toBe  '02:00'
    expect(obj.prettyTime(122)).toBe  '02:02'
    expect(obj.prettyTime(1000)).toBe '16:40'
  it 'prettyTime() rejects non-numeric arguments', ->
    expect(obj.prettyTime('10')).toBe false
    expect(obj.prettyTime(NaN)).toBe false
    expect(obj.prettyTime(null)).toBe false
