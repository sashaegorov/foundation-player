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
  return it('isNumber(x) rejects strings', function() {
    return expect(obj.isNumber('1')).toBe(false);
  });
});
