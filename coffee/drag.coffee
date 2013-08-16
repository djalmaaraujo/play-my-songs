class @Drag
  constructor: ->
    @holder = $('#playlist')

    @handleDragOver()
    @handleDragDrop()

  handleDragOver: ->
    @holder.on 'dragover', (event) =>
      event.preventDefault()

      @holder.addClass('drag-over')

  handleDragDrop: ->
    @holder.on 'drop', (event) =>
      event.preventDefault()

      new Playlist(event.dataTransfer.files)
