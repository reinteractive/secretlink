$(function () {
  function TwoFactorFields(rootDom) {
    this.$root = $(rootDom);
    this.$otpRequiredCheckbox = this.$root.find('.otp-required-for-login');
    this.$enableOtpFields = this.$root.find('.enable-otp-fields');
    this.init();
  }

  TwoFactorFields.prototype.init = function () {
    this.$enableOtpFields.toggle(this.isOtpRequired());

    this.$otpRequiredCheckbox.change(function() {
      this.$enableOtpFields.toggle(this.isOtpRequired());
    }.bind(this));
  }

  TwoFactorFields.prototype.isOtpRequired = function () {
    return this.$otpRequiredCheckbox.is(':checked');
  }

  //Intialization code
  const $hooks = $(this).find(".two-factor-fields");
  $hooks.each(function () {
    new TwoFactorFields(this)
  })
});
