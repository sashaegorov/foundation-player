describe('CoffeeScript suite', function() {
  beforeEach(function() {
    var player;
    jasmine.getFixtures().load('player.html');
    $('.no-1').foundationPlayer();
    return player = $('.no-1').data('FoundationPlayer');
  });
  it('Initializes player', function() {
    expect(player).toBeDefined();
  });
  return it('It has CoffeeScript support:)', function() {
    expect(true).toBe(true);
    expect(true).not.toBe(false);
  });
});
