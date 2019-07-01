module RetrieveSecret
  extend ActiveSupport::Concern

  included do
    def retrieve_secret
      @secret = Secret.find_by(uuid: params[:id])
      case
      when @secret.expired?
        flash[:error] = t('secrets.expired_error')
        redirect_to(root_path)
      when @secret.present? && SecretService.correct_key?(@secret, params[:key])
        @secret
      else
        flash[:error] = "Sorry, we couldn't find that secret"
        redirect_to(root_path)
      end
    end
  end
end
