describe('Private function isNumber(x) suite', function() {
  beforeEach(function() {
    var player;
    jasmine.getFixtures().load('player.html');
    $('.no-1').foundationPlayer();
    return player = $('.no-1').data('FoundationPlayer');
  });
  it('(x) detects correct numbers', function() {
    expect(player.testingAPI().isNumber(1)).toBe(true);
    expect(player.testingAPI().isNumber(null)).not.toBe(true);
    expect(player.testingAPI().isNumber(NaN)).not.toBe(true);
  });
  return it('isNumber(x) rejects strings', function() {
    expect(player.testingAPI().isNumber('1')).not.toBe(true);
  });
});
