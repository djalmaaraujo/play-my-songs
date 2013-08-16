class Playlist
  constructor: ->
    if @checkForFileAPISupport()
      @setElements()
      @createAudioAPIElements()
      @handlers()

    else
      alert "Your browser don't support drag and drop, get out of here!"

  checkForFileAPISupport: ->
    typeof window.FileReader is 'function'

  setElements: ->
    @holder = $('#playlist')
    @player = $('#player')

  handlers: ->
    @handleDragOver()
    @handleDragDrop()
    @handlerPlaySong()

  handleDragOver: ->
    @holder.on 'dragover', (event) =>
      event.preventDefault()

      @holder.addClass('drag-over')

  handleDragDrop: ->
    @holder.on 'drop', (event) =>
      event.preventDefault()

      @populatePlaylist(event.dataTransfer.files)

  handlerPlaySong: ->
    @holder.on 'click', (event) =>
      event.preventDefault()

      songID = $(event.target).data('song')

      @play(songID)

  populatePlaylist: (songs) ->
    @storage = songs

    @holder.html('')

    @insertSong(song, _i) for song in songs

    @play(0)

  play: (songID) ->
    self = @

    unless (@storage[songID])
      alert 'Song not found'

    else
      @stop()

      file = new FileReader()

      file.onload = (fileEvent) ->
        self.createAudio(fileEvent.target.result)

      file.readAsArrayBuffer(@storage[songID])

      @removeActiveClass()
      @holder.find('a.song-' + songID + '').parent().addClass('active')

  stop: ->
    @audioSource.stop(0) if @audioSource
    @createAudioAPIElements()

  removeExtension: (song) ->
    song.split('.')[0]

  createAudioAPIElements: ->
    @audioContext = new (window.AudioContext || window.webkitAudioContext)()
    @audioSource = @audioContext.createBufferSource()

  createAudio: (data) ->
    self = @

    if (self.audioContext.decodeAudioData)
      self.audioContext.decodeAudioData(data, (buffer) ->
          self.audioSource.buffer = buffer
          self.audioSource.connect(self.audioContext.destination)
          self.audioSource.start(0)

        , (e) ->
          alert 'Error loading this file'
        )

  insertSong: (song, index) ->
    if song.type.match(/audio.*/)
      @holder.append '<li><a href="#" data-song="' + index + '" class="song-' + index + '">' + @removeExtension(song.name) + '</a></li>'

  removeActiveClass: ->
    @holder.find('li').removeClass('active')

@Playlist = Playlist
