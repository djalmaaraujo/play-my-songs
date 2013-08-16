class @Playlist
  constructor: (@storage) ->
    @playlist = $('#playlist')

    @populatePlaylist()
    @handlerPlaySong()
    @play(0)

  handlerPlaySong: ->
    @playlist.on 'click', (event) =>
      event.preventDefault()

      songID = $(event.target).data('song')

      @play(songID)

  populatePlaylist: () ->
    @playlist.html('')

    @insertSong(song, _i) for song in @storage

  play: (songID) ->
    self = @

    if (@storage[songID])
      @stop()
      @loadFile(songID)
      @removeActiveClass()
      @playlist.find('a.song-' + songID + '').parent().addClass('active')

  stop: ->
    @audioSource.stop(0) if @audioSource
    @createAudioAPIElements()

  loadFile: (songID) ->
    self = @
    file = new FileReader()

    file.onload = (fileEvent) ->
      self.decodeAudio(fileEvent.target.result)

    file.readAsArrayBuffer(@storage[songID])

  removeExtension: (song) ->
    song.split('.')[0]

  createAudioAPIElements: ->
    @audioContext = new (window.AudioContext || window.webkitAudioContext)()
    @audioSource = @audioContext.createBufferSource()

  decodeAudio: (data) ->
    self = @

    if (self.audioContext.decodeAudioData)
      self.audioContext.decodeAudioData(data, (buffer) ->
          self.audioSource.buffer = buffer
          self.audioSource.connect(self.audioContext.destination)
          self.audioSource.start(0)

          setTimeout(->
              self.stop()
            , self.audioSource.buffer.duration * 1000 +1000);

        , (e) ->
          alert 'Error loading this file'
        )

  insertSong: (song, index) ->
    if song.type.match(/audio.*/)
      @playlist.append '<li><a href="#" data-song="' + index + '" class="song-' + index + '">' + @removeExtension(song.name) + '</a></li>'

  removeActiveClass: ->
    @playlist.find('li').removeClass('active')
