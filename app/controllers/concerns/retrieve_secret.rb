module RetrieveSecret
  extend ActiveSupport::Concern

  included do
    def retrieve_secret
      @secret = Secret.find_by(uuid: params[:id])
      case
      when @secret.expired?
        flash[:error] = "Sorry, that secret has expired, please ask the person who sent it to you to send it again."
        redirect_to(new_auth_token_path)
      when @secret.present? && SecretService.correct_key?(@secret, params[:key])
        @secret
      else
        flash[:error] = "Sorry, we couldn't find that secret"
        redirect_to(new_auth_token_path)
      end
    end
  end
end