$(function() {
  function NewSecretForm(rootDom) {
    this.$root = $(rootDom);
    this.$noEmailToggle = this.$root.find('.no-email-toggle');
    this.$fromEmailField = this.$root.find('.secret_from_email');
    this.$toEmailField = this.$root.find('.secret_to_email');
    this.$toEmailInput = this.$root.find("input[name='secret[to_email]']")
    this.init();
  }

  NewSecretForm.prototype.init = function () {
    this.$noEmailToggle.change(function() {
      this.toggleEmailFields(!this.withoutEmail());
    }.bind(this));
  }

  NewSecretForm.prototype.toggleEmailFields = function (showField) {
    this.$fromEmailField.toggle(showField);
    this.$toEmailField.toggle(showField);
    this.$toEmailInput.val('');
  }

  NewSecretForm.prototype.withoutEmail = function () {
    return this.$noEmailToggle.is(':checked');
  }

  //Intialization code
  const $newSecretForm = $(this).find(".js-new-secret-form");
  $newSecretForm.each(function () {
    new NewSecretForm(this)
  })
});
