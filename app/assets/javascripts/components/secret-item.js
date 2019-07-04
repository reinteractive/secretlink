$(document).ready(function() {
  function SecretItem(rootDom) {
    this.$root = $(rootDom);
    this.$notes = this.$root.find('.notes');
    this.init();
  }

  SecretItem.prototype.init = function () {
    this.$seeNoteBtn = this.$root.find('.notes-trigger');
    this.$seeNoteBtn.on('click', this.toggleNote.bind(this));
  }

  SecretItem.prototype.toggleNote = function () {
    this.$notes.toggle('fast');
  }

  //Intialization code
  const $secretItems = $(this).find(".secret-item");
  $secretItems.each(function () {
    new SecretItem(this)
  })
});
