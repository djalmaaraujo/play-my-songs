// Generated by CoffeeScript 1.6.3
(function() {
  this.Drag = (function() {
    function Drag() {
      this.holder = $('#playlist');
      this.handleDragOver();
      this.handleDragDrop();
    }

    Drag.prototype.handleDragOver = function() {
      var _this = this;
      return this.holder.on('dragover', function(event) {
        event.preventDefault();
        return _this.holder.addClass('drag-over');
      });
    };

    Drag.prototype.handleDragDrop = function() {
      var _this = this;
      return this.holder.on('drop', function(event) {
        event.preventDefault();
        return new Playlist(event.dataTransfer.files);
      });
    };

    return Drag;

  })();

}).call(this);