describe('Audio loading tests suite', function() {
  var no1;
  no1 = null;
  beforeEach(function() {
    loadFixtures('player.html');
    $('.no-1').foundationPlayer();
    return no1 = $('.no-1').data('FoundationPlayer');
  });
  afterEach(function() {
    return no1 = null;
  });
  it('it can\'t play by default', function() {
    return expect(no1.canPlayCurrent).toBe(false);
  });
  it('it doesn\'t play by default', function() {
    return expect(no1.options.playOnLoad).toBe(false);
  });
  xit('it can play after loading', function() {
    no1.audio.load();
    return expect(true).toBe(true);
  });
  return it('audio element has all handlers', function() {
    var $audio;
    $audio = $(no1.audio);
    expect($audio).toHandle('loadstart');
    expect($audio).toHandle('timeupdate');
    expect($audio).toHandle('durationchange');
    expect($audio).toHandle('progress');
    return expect($audio).toHandle('canplay');
  });
});
