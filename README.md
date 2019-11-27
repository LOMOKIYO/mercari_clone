# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## usersテーブル 

|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false|
|email|string|unique: true|
|password|string|unique: true|
|first_name|string|null: false|
|last_name|string|null: false|
|first_name_kana|string|null: false|
|last_name_kana|string|null: false|
|year_birth_at|integer|null: false|
|month_birth_at|integer|null: false|
|day_birth_at|integer|null: false|
|user_id|integer|null: false, foreign_key: true|

### Association
- has_many :buyed_items,foreign_key:"buyer_id", class_name: "Item"
- has_many :saling_items, -> { where("buyer_id is NULL") }, foreign_key: "saler_id", class_name: "Item"
- has_many :sold_items, -> { where("buyer_id is not NULL") }, foreign_key: "saler_id", class_name: "Item"
- has_one :adress
- has_one :profile
- has_many :comments

## addressesテーブル

|Column|Type|Options|
|------|----|-------|
|postal_code|string|null: false|
|prefectures|string|null: false|
|city|string|null: false|
|house_number|string|null: false|
|building_name|string|
|user_id|integer|null: false, foreign_key: true|
|phone_number|string|

### Association
- belongs_to :user

## cardsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer| null: false|
|customer_id|integer| null: false|
|card_id|integer| null: false|

### Association
- belongs_to :user

## itemsテーブル 

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|description|text|null: false|
|state|string|null: false|
|size|string| 
|method|string|null: false|
|region|string|null: false|
|date|string|null: false|
|price|integer|null: false|
|saler_id|integer|null: false|
|buyer_id|integer|

### Association
- belongs_to :saler, class_name: "User"
- belongs_to :buyer, class_name: "User"
- has_many :photos
- belongs_to :brand
- belongs_to :category
- has_many :comments

## photosテーブル 

|Column|Type|Options|
|------|----|-------|
|url|string|null: false|
|item_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :item

## brandsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|

### Association
- has_many :items

## categoriesテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestory|string| 

### Association
- has_many :items

## commentsテーブル

|Column|Type|Options|
|------|----|-------|
|text|text|null: false|
|user_id|integer|null: false, foreign_key: true|
|item_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :item