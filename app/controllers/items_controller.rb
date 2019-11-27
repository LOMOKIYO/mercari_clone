class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :buy, :pay, :detail, :destroy]
  before_action :set_item_find, only:[:destroy]
  before_action :set_selling, only: [:index, :show]
  before_action :set_item, only: [:show, :buy, :pay, :edit, :update]
  before_action :set_card, only: [:buy, :pay]
  before_action :redirect_back, only: :edit

  def index
    @populer_categories = Category.find(1,219,985,378)
    @ladies_items = @selling_items.where(category_id: 1..218).limit(10).order('created_at DESC')
    @mens_items = @selling_items.where(category_id: 219..377).limit(10).order('created_at DESC')
    @electronics_items = @selling_items.where(category_id: 985..1080).limit(10).order('created_at DESC')
    @hobby_items = @selling_items.where(category_id: 378..531).limit(10).order('created_at DESC')

    @populer_brands = Brand.find(2441,6143,2461,3803)
    @chanel_items = @selling_items.where(brand_id: 2441).limit(10).order('created_at DESC')
    @vuitton_items = @selling_items.where(brand_id: 6143).limit(10).order('created_at DESC')
    @supreme_items = @selling_items.where(brand_id: 2461).limit(10).order('created_at DESC')
    @naiki_items = @selling_items.where(brand_id: 3803).limit(10).order('created_at DESC')
  end

  def new
    @items = Item.new
    1.times { @items.photos.build }
  end


def create
  @item = Item.new(item_params)
  if @item.save
    redirect_to root_path
  else
    redirect_back(fallback_location: new_item_path)
  end
  
end

def edit
  10.times { @item.photos.build }
end

def redirect_back
  if @item.saler_id != current_user.id
    redirect_to root_path
  end
end

def update
  if @item.saler_id == current_user.id && @item.update(update_params)
    redirect_to item_path(@item)
  else 
    redirect_back(fallback_location: "/items/new")
  end
end

  def show
    @saler = User.find(@item.saler_id)
    @saler_items = @selling_items.where(saler_id: @saler.id).limit(6).order('created_at DESC')
    @category = Category.find(@item.category_id)
    @category_items = @category.items.limit(6).order('created_at DESC')
    @comments = @item.comments.includes(:user)
    @comment = Comment.new
    if @item.brand_id  
      @brand = Brand.find(@item.brand_id)
    end
  end

  def buy
    if @card.blank?
      #登録された情報がない場合にカード登録画面に移動
      # redirect_to controller: "card", action: "new"
    else
      Payjp.api_key = 'sk_test_5d0971e062081646be8df08b'
      #保管した顧客IDでpayjpから情報取得
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(@card.card_id)
    end

    # if user_signed_in? && current_user.address
    @address = current_user.address
  end

  def pay
    if @card.blank?
      redirect_to buy_item_path
    else
      Payjp.api_key = 'sk_test_5d0971e062081646be8df08b'
      Payjp::Charge.create(
      amount: @item.price, #支払金額を入力（itemテーブル等に紐づけても良い）
      customer: @card.customer_id, #顧客ID
      currency: 'jpy', #日本円
      )
      item_update
      redirect_to  bought_mypages_path #完了画面に移動
    end
  end

  def destroy
    if @item.saler_id == current_user.id && @item.destroy
      redirect_to root_path
    else 
      redirect_to items_path(@item)
    end
  end

  

  private

  def set_item
    @item = Item.includes(:photos).find(params[:id])
  end


  def item_params
    params.require(:item).permit(
      :name, 
      :description, 
      :state, 
      :size, 
      :method, 
      :carriage, 
      :region, 
      :date, 
      :price,
      :category_id,
      :brand_id,
      photos_attributes: [:image]
    ).merge(saler_id: current_user.id)
  end

  def update_params
    params.require(:item).permit(
      :name, 
      :description, 
      :state, 
      :size, 
      :method, 
      :carriage, 
      :region, 
      :date, 
      :price,
      :category_id,
      :brand_id,
      photos_attributes: [:image, :_destroy, :id]
    ).merge(saler_id: current_user.id)
  end

  def set_item_find
    @item = Item.find(params[:id])
  end

  def item_update
    @item.update(name: @item.name, description: @item.description, state: @item.state, size: @item.state, method: @item.method, carriage: @item.carriage, region: @item.region, date: @item.date, price: @item.price, category_id: @item.category_id, saler_id: @item.saler_id, buyer_id: current_user.id)
  end

  def set_card
    @card = current_user.card
  end
  
end