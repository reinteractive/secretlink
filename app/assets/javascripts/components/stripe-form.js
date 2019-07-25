$(function() {
  function StripeForm (rootDom, key) {
    this.$root = $(rootDom);
    this.$cardElement = this.$root.find("#card-element")
    this.$errorView = this.$root.find("#card-errors");

    this.stripe = Stripe(key);
    this.elements = this.stripe.elements();

    this.init();
  }

  StripeForm.prototype.init = function () {
    var card = this.initCard();
    this.handleSumbit(card);
    this.handleErrors(card);
  };

  StripeForm.prototype.initCard = function () {
    var styles = this.cardStyles();
    var card = this.elements.create('card', {style: styles});
    card.mount(this.$cardElement[0]);
    return card;
  }

  StripeForm.prototype.handleErrors = function (card) {
    card.addEventListener("change", function(event) {
      if (event.error) {
        this.showError(event.error.message);
      } else {
        this.clearError();
      }
    }.bind(this));
  }

  StripeForm.prototype.handleSumbit = function (card) {
    this.$root.on("submit", function(event) {
      event.preventDefault();

      this.stripe.createSource(card).then(function(result) {
        if (result.error) {
          this.showError(result.error.message);
        } else {
          this.$root.off("submit");
          this.submitSourceResponse(result.source);
        }
      }.bind(this));
    }.bind(this));
  }

  StripeForm.prototype.submitSourceResponse = function (source) {
    // Insert the source ID into the form so it gets submitted to the server
    // TODO: Don't we need client_secret in server?
    var form = this.$root;
    var hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripe_source');
    hiddenInput.setAttribute('value', source.id);
    form.append(hiddenInput);

    form.submit();
  }

  StripeForm.prototype.showError = function (text) {
    this.$errorView.text(text);
  };

  StripeForm.prototype.clearError = function () {
    this.$errorView.text('');
  };

  StripeForm.prototype.cardStyles = function () {
    return {
      base: {
        fontSize: '16px',
        color: "#32325d",
      }
    };
  };

  //Intialization code
  const $newStripeForms = $(this).find(".js-stripe-form");
  $newStripeForms.each(function () {
    var key = $(this).data('key');
    new StripeForm(this, key);
  })
});
