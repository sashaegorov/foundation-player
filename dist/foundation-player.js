(function() {
  var slice = [].slice;

  (function($, window) {
    'use strict';
    var FoundationPlayer;
    FoundationPlayer = (function() {
      var isNumber, parseSeekPercent, parseSeekTime, prettyTime, stringPadLeft, switchClass;

      FoundationPlayer.prototype.defaults = {
        size: 'normal',
        playOnLoad: false,
        skipSeconds: 10,
        dimmedVolume: 0.25,
        pauseOthersOnPlay: true,
        useSeekData: false
      };

      function FoundationPlayer(el, opt) {
        this.options = $.extend({}, this.defaults, opt);
        this.$wrapper = $(el);
        this.$player = this.$wrapper.children('.player');
        this.$play = this.$wrapper.find('.player-button.play em');
        this.$rewind = this.$wrapper.find('.player-button.rewind em');
        this.$volume = this.$wrapper.find('.player-button.volume em');
        this.$elapsed = this.$wrapper.find('.player-status.time .elapsed');
        this.$remains = this.$wrapper.find('.player-status.time .remains');
        this.$progress = this.$wrapper.find('.player-progress .progress');
        this.$played = this.$progress.find('.progress-meter.played');
        this.$sources = this.$wrapper.children('audio');
        this.audio = this.$sources.get(0);
        this.played = 0;
        this.nowdragging = false;
        this.currentUISize = this.options.size;
        this.canPlayCurrent = false;
        this.dataLinks = [];
        this.resetClassAndStyle();
        this.setUpCurrentAudio();
        this.setUpButtonPlayPause();
        this.setUpButtonVolume();
        this.setUpButtonRewind();
        this.setUpPlayedProgress();
        if (this.options.useSeekData) {
          this.parseDataLinks();
        }
      }

      FoundationPlayer.prototype.playPause = function() {
        if (this.audio.paused) {
          return this.play();
        } else {
          return this.pause();
        }
      };

      FoundationPlayer.prototype.play = function() {
        if (this.options.pauseOthersOnPlay) {
          this.getPlayerInstances().map((function(_this) {
            return function(p) {
              if (_this !== p) {
                return p.pause();
              }
            };
          })(this));
        }
        this.audio.play();
        return this.updateButtonPlay();
      };

      FoundationPlayer.prototype.pause = function() {
        this.audio.pause();
        return this.updateButtonPlay();
      };

      FoundationPlayer.prototype.seekToTime = function(time) {
        if (this.canPlayCurrent) {
          time = parseSeekTime(time);
          if (time > this.audio.duration) {
            time = this.audio.duration;
          }
          this.audio.currentTime = time;
          this.updatePlayedProgress();
          this.updateTimeStatuses();
        }
        return this;
      };

      FoundationPlayer.prototype.seekPercent = function(p) {
        var timeToGo;
        timeToGo = this.audio.duration * parseSeekPercent(p);
        this.audio.currentTime = timeToGo || 0;
        this.updatePlayedProgress();
        this.updateTimeStatuses();
        return this;
      };

      FoundationPlayer.prototype.resetClassAndStyle = function() {
        this.$wrapper.addClass(this.options.size);
        return this.setPlayerSizeHandler();
      };

      FoundationPlayer.prototype.setUpCurrentAudio = function() {
        var $audio;
        this.audio.load();
        $audio = $(this.audio);
        $audio.on('timeupdate.zf.player', (function(_this) {
          return function() {
            _this.updatePlayedProgress();
            return _this.updateTimeStatuses();
          };
        })(this));
        $audio.on('loadstart.zf.player', (function(_this) {
          return function() {
            _this.canPlayCurrent = false;
            _this.updateDisabledStatus();
            return _this.updateButtonPlay();
          };
        })(this));
        $audio.on('durationchange.zf.player', (function(_this) {
          return function() {
            return _this.updateTimeStatuses();
          };
        })(this));
        $audio.on('progress.zf.player', (function(_this) {
          return function() {
            _this.redrawBufferizationBars();
            return _this.updateDisabledStatus();
          };
        })(this));
        return $audio.on('canplay.zf.player', (function(_this) {
          return function() {
            _this.canPlayCurrent = true;
            if (_this.options.playOnLoad) {
              _this.play();
            }
            _this.redrawBufferizationBars();
            _this.updateDisabledStatus();
            return _this.updateButtonPlay();
          };
        })(this));
      };

      FoundationPlayer.prototype.setUpButtonPlayPause = function() {
        return this.$play.bind('click', (function(_this) {
          return function() {
            if (_this.canPlayCurrent) {
              return _this.playPause();
            }
          };
        })(this));
      };

      FoundationPlayer.prototype.updateButtonPlay = function() {
        this.$play.toggleClass('fi-music', !this.canPlayCurrent);
        this.$play.toggleClass('fi-pause', this.audio.paused && this.canPlayCurrent);
        this.$play.toggleClass('fi-play', !this.audio.paused);
        return this;
      };

      FoundationPlayer.prototype.setUpButtonVolume = function() {
        return this.$volume.bind('click.zf.player', (function(_this) {
          return function() {
            return _this.buttonVolumeHandler();
          };
        })(this));
      };

      FoundationPlayer.prototype.updateButtonVolume = function() {
        if (this.audio.muted) {
          return switchClass(this.$volume, 'fi-volume-strike', 'fi-volume');
        } else {
          return switchClass(this.$volume, 'fi-volume', 'fi-volume-strike');
        }
      };

      FoundationPlayer.prototype.buttonVolumeHandler = function() {
        this.toggleMute();
        return this.updateButtonVolume();
      };

      FoundationPlayer.prototype.setUpButtonRewind = function() {
        return this.$rewind.on('click', (function(_this) {
          return function() {
            return _this.seekToTime(_this.audio.currentTime - _this.options.skipSeconds);
          };
        })(this));
      };

      FoundationPlayer.prototype.setUpPlayedProgress = function() {
        var _stopDragHandler;
        this.$played.css('width', this.played + '%');
        this.$progress.on('click.zf.player', (function(_this) {
          return function(e) {
            return _this.seekPercent(Math.floor(100 * e.offsetX / _this.$progress.outerWidth()));
          };
        })(this));
        this.$progress.on('mousedown.zf.player', (function(_this) {
          return function() {
            _this.nowdragging = true;
            return _this.setVolume(_this.options.dimmedVolume);
          };
        })(this));
        _stopDragHandler = (function(_this) {
          return function() {
            if (_this.nowdragging) {
              _this.nowdragging = false;
              return _this.setVolume(1);
            }
          };
        })(this);
        this.$player.on('mouseleave.zf.player', function() {
          return _stopDragHandler();
        });
        $(document).on('mouseup.zf.player', function() {
          return _stopDragHandler();
        });
        $(window).on('blur.zf.player', function() {
          return _stopDragHandler();
        });
        return this.$progress.on('mousemove.zf.player', (function(_this) {
          return function(e) {
            if (_this.nowdragging) {
              return _this.seekPercent(Math.floor(100 * e.offsetX / _this.$progress.outerWidth()));
            }
          };
        })(this));
      };

      FoundationPlayer.prototype.updatePlayedProgress = function() {
        this.played = Math.round(this.audio.currentTime / this.audio.duration * 100);
        return this.$played.css('width', this.played + '%');
      };

      FoundationPlayer.prototype.redrawBufferizationBars = function() {
        var b, e, i, range, ref, results, segments, w;
        this.$progress.find('.buffered').remove();
        segments = this.audio.buffered.length;
        if (segments > 0) {
          w = this.$progress.width();
          results = [];
          for (range = i = 0, ref = segments; 0 <= ref ? i < ref : i > ref; range = 0 <= ref ? ++i : --i) {
            b = this.audio.buffered.start(range);
            e = this.audio.buffered.end(range);
            results.push(switchClass(this.$played.clone(), 'buffered', 'played').css('left', (w * (Math.floor(b / this.audio.duration))) + 'px').width(Math.floor(w * (e - b) / this.audio.duration)).appendTo(this.$progress));
          }
          return results;
        }
      };

      FoundationPlayer.prototype.setVolume = function(vol) {
        return this.audio.volume = vol;
      };

      FoundationPlayer.prototype.toggleMute = function() {
        return this.audio.muted = !this.audio.muted;
      };

      FoundationPlayer.prototype.updateTimeStatuses = function() {
        this.updateStatusElapsed();
        return this.updateStatusRemains();
      };

      FoundationPlayer.prototype.updateStatusElapsed = function() {
        return this.$elapsed.text(prettyTime(this.audio.currentTime));
      };

      FoundationPlayer.prototype.updateStatusRemains = function() {
        return this.$remains.text('-' + prettyTime(this.audio.duration - this.audio.currentTime));
      };

      FoundationPlayer.prototype.updateDisabledStatus = function() {
        return this.$player.toggleClass('disabled', !this.canPlayCurrent);
      };

      FoundationPlayer.prototype.togglePlayerSize = function() {
        var toSize;
        toSize = this.currentUISize === 'normal' ? 'small' : 'normal';
        if (this.setPlayerSize(toSize)) {
          return this.currentUISize = toSize;
        }
      };

      FoundationPlayer.prototype.setPlayerSize = function(size) {
        if (size !== this.currentUISize) {
          if ('normal' === size || 'small' === size) {
            switchClass(this.$wrapper, size, this.currentUISize);
            this.setPlayerSizeHandler();
            return this.currentUISize = size;
          } else {
            console.error('setPlayerSize: incorrect size argument');
            return false;
          }
        }
      };

      FoundationPlayer.prototype.setPlayerSizeHandler = function() {
        this.playerBeautifyProgressBar();
        return this.redrawBufferizationBars();
      };

      FoundationPlayer.prototype.playerBeautifyProgressBar = function() {
        var semiHeight;
        if (this.$progress.hasClass('round')) {
          semiHeight = this.$progress.height() / 2;
          this.$played.css('padding', "0 " + semiHeight + "px");
          return this.$progress.find('.buffered').css('padding', "0 " + semiHeight + "px");
        }
      };

      FoundationPlayer.prototype.getPlayerInstances = function() {
        return $.data(document.body, 'FoundationPlayers');
      };

      FoundationPlayer.prototype.parseDataLinks = function() {
        var clсk, percentLinks, timeLinks;
        this.dataLinks = [];
        timeLinks = $('[data-seek-to-time]');
        percentLinks = $('[data-seek-to-percentage]');
        clсk = 'click.zf.player.seek';
        $.each(timeLinks, (function(_this) {
          return function(index, el) {
            var parsedData;
            if (parsedData = parseSeekTime($(el).data('seek-to-time'))) {
              _this.dataLinks.push(el);
              return $(el).off(clсk).on(clсk, _this, function(e) {
                e.preventDefault();
                return e.data.seekToTime(parsedData);
              });
            }
          };
        })(this));
        return $.each(percentLinks, (function(_this) {
          return function(index, el) {
            var parsedData;
            if (parsedData = parseSeekPercent($(el).data('seek-to-percentage'))) {
              _this.dataLinks.push(el);
              return $(el).off(clсk).on(clсk, _this, function(e) {
                e.preventDefault();
                return e.data.seekPercent(parsedData);
              });
            }
          };
        })(this));
      };

      switchClass = function(element, p, n) {
        return $(element).addClass(p).removeClass(n);
      };

      prettyTime = function(s) {
        var min, sec;
        if (!isNumber(s)) {
          return false;
        }
        min = Math.floor(s / 60);
        sec = s - min * 60;
        return (stringPadLeft(min, '0', 2)) + ':' + (stringPadLeft(Math.floor(sec / 1), '0', 2));
      };

      stringPadLeft = function(string, pad, length) {
        return (new Array(length + 1).join(pad) + string).slice(-length);
      };

      isNumber = function(x) {
        return typeof x === 'number' && isFinite(x);
      };

      parseSeekTime = function(time) {
        var m;
        if (isNumber(time)) {
          return time;
        } else if (m = time.match(/^(\d{1,})$/)) {
          return m[1];
        } else if (m = time.match(/^(\d?\d):(\d\d)$/)) {
          return (parseInt(m[1], 10)) * 60 + (parseInt(m[2], 10));
        } else {
          return false;
        }
      };

      parseSeekPercent = function(p) {
        if (!isNumber(p)) {
          return isNumber(p);
        }
        if (p < 0) {
          return 0;
        }
        if (p > 100) {
          return 1;
        }
        if (p > 1) {
          return p / 100;
        } else {
          return p;
        }
      };



      return FoundationPlayer;

    })();

    return $.fn.extend({
      foundationPlayer: function() {
        var args, option;
        option = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        if (!$.data(document.body, 'FoundationPlayers')) {
          $.data(document.body, 'FoundationPlayers', []);
        }
        return this.each(function() {
          var fplayer;
          if (!$.data(this, 'FoundationPlayer')) {
            fplayer = new FoundationPlayer(this, option);
            $.data(this, 'FoundationPlayer', fplayer);
            return $.data(document.body, 'FoundationPlayers').push(fplayer);
          }
        });
      }
    });
  })(window.jQuery, window);

}).call(this);
