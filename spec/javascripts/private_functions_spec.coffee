# Test Foundation Player private functions
describe 'Private functions suite', ->
  obj = null

  beforeEach ->
    # Fixtures
    jasmine.getFixtures().fixturesPath = '.'
    loadFixtures 'spec/javascripts/fixtures/html/player-1.html'
    # Setup
    $('.no-1').foundationPlayer()
    obj = $('.no-1').data('FoundationPlayer').testingAPI()

  afterEach ->
    obj = null
    $.removeData document.body, 'FoundationPlayers'

  it 'isNumber() detects correct numbers', ->
    expect(obj.isNumber 1).toBe true
    expect(obj.isNumber 42).toBe true
    expect(obj.isNumber null).not.toBe true
    expect(obj.isNumber NaN).not.toBe true

  it 'isNumber() rejects strings', ->
    expect(obj.isNumber('1')).toBe false
    expect(obj.isNumber('42')).not.toBe true

  it 'stringPadLeft() adds additional 00', ->
    expect(obj.stringPadLeft '.', 'X', 5).toBe 'XXXX.'
    expect(obj.stringPadLeft 5, '0', 3).toBe '005'
    expect(obj.stringPadLeft 'x', '0', 2).toBe '0x'

  it 'prettyTime() returns formated time', ->
    expect(obj.prettyTime 0).toBe '00:00'
    expect(obj.prettyTime 10).toBe  '00:10'
    expect(obj.prettyTime 60).toBe  '01:00'
    expect(obj.prettyTime 120).toBe  '02:00'
    expect(obj.prettyTime 122).toBe  '02:02'
    expect(obj.prettyTime 1000).toBe '16:40'
    expect(obj.prettyTime 4.424242, '0', 3).toBe '00:04'
    expect(obj.prettyTime 4.424242, '0', 3).not.toBe '00:42'
    expect(obj.prettyTime 12.34567, '0', 3).toBe '00:12'
    expect(obj.prettyTime 12.34567, '0', 3).not.toBe '00:67'


  it 'prettyTime() rejects non-numeric arguments', ->
    expect(obj.prettyTime '10').toBe false
    expect(obj.prettyTime NaN).toBe false
    expect(obj.prettyTime null).toBe false

  it 'switchClass() switches classes', ->
    setFixtures('<hr class="dummy foo" />')
    $el = $('.dummy')
    expect($el).toHaveClass 'dummy'
    expect($el).toHaveClass 'foo'
    expect($el).not.toHaveClass 'bar'
    obj.switchClass($el, 'bar', 'foo')
    expect($el).toHaveClass 'dummy'
    expect($el).toHaveClass 'bar'
    expect($el).not.toHaveClass 'foo'

  it 'parseSeekTime() parses numeric', ->
    expect(obj.parseSeekTime 0).toBe 0
    expect(obj.parseSeekTime 1).toBe 1
    expect(obj.parseSeekTime 42).toBe 42
    expect(obj.parseSeekTime 4242).toBe 4242

  it 'parseSeekTime() parses numbers as a string', ->
    expect(obj.parseSeekTime '1').toBe '1'
    expect(obj.parseSeekTime '42').toBe '42'
    expect(obj.parseSeekTime '042').toBe '042'
    expect(obj.parseSeekTime '4242').toBe '4242'
    expect(obj.parseSeekTime '42424242').toBe '42424242'

  it 'parseSeekTime() parses timestamp', ->
    expect(obj.parseSeekTime '00:00').toBe 0
    expect(obj.parseSeekTime '00:10').toBe 10
    expect(obj.parseSeekTime '01:00').toBe 60
    expect(obj.parseSeekTime '02:00').toBe 120
    expect(obj.parseSeekTime '02:02').toBe 122
    expect(obj.parseSeekTime '0:00').toBe 0
    expect(obj.parseSeekTime '0:10').toBe 10
    expect(obj.parseSeekTime '1:00').toBe 60
    expect(obj.parseSeekTime '2:00').toBe 120
    expect(obj.parseSeekTime '2:02').toBe 122
    expect(obj.parseSeekTime '16:40').toBe 1000

  it 'parseSeekTime() returns false for invalid statements', ->
    expect(obj.parseSeekTime '12f').toBe false
    expect(obj.parseSeekTime '0xFF').toBe false
    expect(obj.parseSeekTime '02:2').toBe false
    expect(obj.parseSeekTime '6:4').toBe false
    expect(obj.parseSeekTime '126:24').toBe false
    expect(obj.parseSeekTime '26:124').toBe false

  it 'parseSeekPercent() parses both percentage and float', ->
    # Range from 0.0 to 1.0
    expect(obj.parseSeekPercent 0).toBe 0
    expect(obj.parseSeekPercent 0.5).toBe 0.5
    expect(obj.parseSeekPercent 1).toBe 1
    # Range from > 1.0 to 100
    expect(obj.parseSeekPercent 2).toBe 0.02
    expect(obj.parseSeekPercent 50).toBe 0.5
    expect(obj.parseSeekPercent 100).toBe 1
    # Range from > 100
    expect(obj.parseSeekPercent 150).toBe 1
    # Negative values
    expect(obj.parseSeekPercent -10).toBe 0
    expect(obj.parseSeekPercent -0.1).toBe 0

  it 'parseSeekPercent() rejects any kind strings', ->
    expect(obj.parseSeekPercent '50').toBe false
    expect(obj.parseSeekPercent '-50').toBe false
    expect(obj.parseSeekPercent '0.1').toBe false
    expect(obj.parseSeekPercent '0,1').toBe false
    expect(obj.parseSeekPercent '-0.1').toBe false
    expect(obj.parseSeekPercent '-0,1').toBe false
