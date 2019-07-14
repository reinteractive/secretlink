$(function () {
  function TwoFactorFields(rootDom) {
    this.$root = $(rootDom);
    this.$otpRequiredCheckbox = this.$root.find('.otp-required-for-login');
    this.$enableOtpFields = this.$root.find('.enable-otp-fields');
    this.$enableBtn = this.$root.find('.btn-enable-2fa');
    this.$disableBtn = this.$root.find('.btn-disable-2fa');
    this.init();
  }

  TwoFactorFields.prototype.init = function () {
    this.toggleEnableState(this.isOtpRequired());

    this.$otpRequiredCheckbox.change(function() {
      this.toggleEnableState(this.isOtpRequired());
    }.bind(this));
  }

  TwoFactorFields.prototype.isOtpRequired = function () {
    return this.$otpRequiredCheckbox.is(':checked');
  }

  TwoFactorFields.prototype.toggleEnableState = function (visible) {
    this.$enableBtn.toggle(visible);
    this.$enableOtpFields.toggle(visible);
    this.$disableBtn.toggle(!visible);
  }

  //Intialization code
  const $hooks = $(this).find(".two-factor-fields");
  $hooks.each(function () {
    new TwoFactorFields(this)
  })
});
