class SignupController < ApplicationController

  def step1
    @user = User.new
  end  

  def step2
    session[:nickname]                = user_params[:nickname]
    session[:email]                   = user_params[:email]
    session[:password]                = user_params[:password]
    session[:password_confirmation]   = user_params[:password_confirmation]
    session[:last_name]               = user_params[:last_name]
    session[:first_name]              = user_params[:first_name]
    session[:last_name_kana]          = user_params[:last_name_kana]
    session[:first_name_kana]         = user_params[:first_name_kana]
    session[:birth_year]              = user_params[:birth_year]
    session[:birth_month]             = user_params[:birth_month]
    session[:birth_day]               = user_params[:birth_day]

  end
  
  def step3
    @address = Address.new
  end
    
  def step4
    session[:postal_code]             = address_params[:postal_code]
    session[:prefecture_id]           = address_params[:prefecture_id]
    session[:city]                    = address_params[:city]
    session[:house_number]            = address_params[:house_number]
    session[:building_name]           = address_params[:building_name]
    session[:phone_number]            = address_params[:phone_number]
    binding.pry
    # @card = Card.new

  end

  def create
    @user = User.new(
    nickname:              session[:nickname], 
    email:                 session[:email], 
    password:              session[:password], 
    password_confirmation: session[:password_confirmation], 
    last_name:             session[:last_name], 
    first_name:            session[:first_name], 
    last_name_kana:        session[:last_name_kana], 
    first_name_kana:       session[:first_name_kana], 
    birth_year:            session[:birth_year],
    birth_month:           session[:birth_month],
    birth_day:             session[:birth_day]
    )

    

    if @user.save
      @address = Address.create(
        user_id:               @user.id,
        postal_code:           session[:postal_code],
        prefecture_id:         session[:prefecture_id],  
        city:                  session[:city], 
        house_number:          session[:house_number], 
        building_name:         session[:building_name], 
        phone_number:          session[:phone_number],
        )
      session[:id] = @user.id
      redirect_to done_signup_index_path
    else
      render "/devise/registrations/index"
    end

    def done
      sign_in User.find(seesion[:id]) unless user_signed_in?
    end
  end 
  
  
  private

  def user_params
    params.require(:user).permit(
      :nickname,:email,:password,:password_confirmation,
      :last_name, :first_name, :last_name_kana, :first_name_kana,
      :birth_year, :birth_month, :birth_day
    )
  end
  
  def address_params
    params.require(:address).permit(
      :postal_code,:prefecture_id,:city,
      :house_number,:building_name,:phone_number,
    )
  end
  
end