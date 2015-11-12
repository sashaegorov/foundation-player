describe('CoffeeScript suite', function() {
  var no1;
  no1 = 0;
  beforeEach(function() {
    loadFixtures('player.html');
    $('.no-1').foundationPlayer();
    return no1 = $('.no-1').data('FoundationPlayer');
  });
  afterEach(function() {
    return no1 = 0;
  });
  it('it has CoffeeScript support:)', function() {
    expect(true).toBe(true);
    return expect(false).not.toBe(true);
  });
  it('Initialized player?', function() {
    return expect(no1).toBeDefined();
  });
  it('player has default size', function() {
    return expect(no1.currentUISize).toEqual(no1.options.size);
  });
  it('play() works', function() {
    no1.play();
    return expect(no1.audio.paused).toEqual(false);
  });
  it('paused() works', function() {
    no1.pause();
    return expect(no1.audio.paused).toEqual(true);
  });
  it('playPause() works', function() {
    no1.pause();
    no1.playPause();
    expect(no1.audio.paused).toEqual(false);
    no1.playPause();
    return expect(no1.audio.paused).toEqual(true);
  });
  it('setVolume() works', function() {
    no1.setVolume(0.5);
    return expect(no1.audio.volume).toEqual(0.5);
  });
  it('setPlayerSize() works', function() {
    no1.setPlayerSize('small');
    return expect(no1.currentUISize).toEqual('small');
  });
  it('togglePlayerSize() works', function() {
    no1.setPlayerSize('small');
    no1.togglePlayerSize();
    expect(no1.currentUISize).toEqual('normal');
    no1.togglePlayerSize();
    return expect(no1.currentUISize).toEqual('small');
  });
  return it('toggleMute() works', function() {
    no1.audio.muted = false;
    no1.toggleMute();
    expect(no1.audio.muted).toEqual(true);
    no1.toggleMute();
    return expect(no1.audio.muted).toEqual(false);
  });
});
