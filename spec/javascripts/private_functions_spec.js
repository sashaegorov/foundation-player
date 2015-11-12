describe('Private functions suite', function() {
  var obj;
  obj = {};
  beforeEach(function() {
    jasmine.getFixtures().load('player.html');
    $('.foundation-player').foundationPlayer();
    return obj = $('.no-1').data('FoundationPlayer').testingAPI();
  });
  afterEach(function() {
    return obj = {};
  });
  it('isNumber(x) detects correct numbers', function() {
    expect(obj.isNumber(1)).toBe(true);
    expect(obj.isNumber(null)).not.toBe(true);
    return expect(obj.isNumber(NaN)).not.toBe(true);
  });
  it('isNumber(x) rejects strings', function() {
    return expect(obj.isNumber('1')).toBe(false);
  });
  it('stringPadLeft() adds additional 00', function() {
    var minutes;
    minutes = 5;
    return expect(obj.stringPadLeft(minutes, '0', 3)).toBe('005');
  });
  return it('prettyTime(100) returns 01:40 ', function() {
    expect(obj.prettyTime(10)).toBe('00:10');
    expect(obj.prettyTime(0)).toBe('00:00');
    return expect(obj.prettyTime(1000)).toBe('16:40');
  });
});
