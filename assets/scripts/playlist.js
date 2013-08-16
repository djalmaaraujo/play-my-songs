// Generated by CoffeeScript 1.6.3
(function() {
  this.Playlist = (function() {
    function Playlist(storage) {
      this.storage = storage;
      this.playlist = $('#playlist');
      this.populatePlaylist();
      this.handlerPlaySong();
      this.play(0);
    }

    Playlist.prototype.handlerPlaySong = function() {
      var _this = this;
      return this.playlist.on('click', function(event) {
        var songID;
        event.preventDefault();
        songID = $(event.target).data('song');
        return _this.play(songID);
      });
    };

    Playlist.prototype.populatePlaylist = function() {
      var song, _i, _len, _ref, _results;
      this.playlist.html('');
      _ref = this.storage;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        song = _ref[_i];
        _results.push(this.insertSong(song, _i));
      }
      return _results;
    };

    Playlist.prototype.play = function(songID) {
      var self;
      self = this;
      if (this.storage[songID]) {
        this.stop();
        this.loadFile(songID);
        this.removeActiveClass();
        return this.playlist.find('a.song-' + songID + '').parent().addClass('active');
      }
    };

    Playlist.prototype.stop = function() {
      if (this.audioSource) {
        this.audioSource.stop(0);
      }
      return this.createAudioAPIElements();
    };

    Playlist.prototype.loadFile = function(songID) {
      var file, self;
      self = this;
      file = new FileReader();
      file.onload = function(fileEvent) {
        return self.decodeAudio(fileEvent.target.result);
      };
      return file.readAsArrayBuffer(this.storage[songID]);
    };

    Playlist.prototype.removeExtension = function(song) {
      return song.split('.')[0];
    };

    Playlist.prototype.createAudioAPIElements = function() {
      this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
      return this.audioSource = this.audioContext.createBufferSource();
    };

    Playlist.prototype.decodeAudio = function(data) {
      var self;
      self = this;
      if (self.audioContext.decodeAudioData) {
        return self.audioContext.decodeAudioData(data, function(buffer) {
          self.audioSource.buffer = buffer;
          self.audioSource.connect(self.audioContext.destination);
          self.audioSource.start(0);
          return setTimeout(function() {
            return self.stop();
          }, self.audioSource.buffer.duration * 1000 + 1000);
        }, function(e) {
          return alert('Error loading this file');
        });
      }
    };

    Playlist.prototype.insertSong = function(song, index) {
      if (song.type.match(/audio.*/)) {
        return this.playlist.append('<li><a href="#" data-song="' + index + '" class="song-' + index + '">' + this.removeExtension(song.name) + '</a></li>');
      }
    };

    Playlist.prototype.removeActiveClass = function() {
      return this.playlist.find('li').removeClass('active');
    };

    return Playlist;

  })();

}).call(this);
