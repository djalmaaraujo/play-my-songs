class Playlist
  constructor: () ->
    if @checkForFileAPISupport()
      @setElements()
      @createAudioAPIElements()
      @handlers()
    else
      alert "Your browser don't support drag and drop, get out of here!"

  checkForFileAPISupport: ->
    typeof window.FileReader is 'function'

  setElements: ->
    @holder = document.getElementById('playlist')
    @player = document.getElementById('player')

  handlers: ->
    @handleDragOver()
    @handleDragEnd()
    @handleDragDrop()
    @handlerPlaySong()

  handleDragOver: ->
    @holder.ondragover = (event) ->
      event.target.className = 'drag-over'
      false

  handleDragEnd: ->
    @holder.ondragend = (event) ->
      event.className = ''
      false

  handleDragDrop: ->
    @holder.ondrop = (event) =>
      event.preventDefault()
      event.target.className = ''

      @populate(event.dataTransfer.files)

  handlerPlaySong: ->
    @holder.addEventListener 'click', (event) =>
      event.preventDefault()

      if parseInt(event.target.getAttribute('data-song'), 10) > 0
        @play(event.target.getAttribute('data-song'))

  populate: (songs) ->
    @playlist = songs
    @addSong(song, _i) for song in songs
    @play(0)

  addSong: (song, index) ->
    if song.type.match(/audio.*/)
      @holder.innerHTML += '<li><a href="#" data-song="' + index + '">' + @removeExtension(song.name) + '</a></li>'

  removeExtension: (song) ->
    song.split('.')[0]

  play: (songID) ->
    self = @

    unless (@playlist[songID])
      alert 'Song not found'

    else
      @stop()
      file = new FileReader()

      file.onload = (fileEvent) ->
        data = fileEvent.target.result
        self.createAudio(data)

      file.readAsArrayBuffer(@playlist[songID])

  stop: ->
    @audioSource.stop(0) if @audioSource
    @createAudioAPIElements()

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

@Playlist = Playlist