# frozen_string_literal: true

## ApplicationRecordはActiveRecordを継承
## https://api.rubyonrails.org/v7.0/classes/ActiveRecord/Callbacks/ClassMethods.html#method-i-before_save
class User < ApplicationRecord
  ####################
  ## クラスメソッド ##
  ####################
  ## c#ではstatic methodのことをクラスメソッドというらしいから
  ## つまりは動作がインスタンス間で関係ないやつのことかなぁ
  ## Factoryパターンとかこれ使うっけ
  ##
  ## => つまり、そう、static method
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost:)
    end

    ## ランダムなトークンを生成
    def new_token
      SecureRandom.urlsafe_base64
    end

    def inspect(password, password_digest)
      BCrypt::Password.new(password_digest).is_password?(password)
    end
  end

  attr_accessor :remember_token, :activation_token, :reset_token

  ## micropostを複数持つ
  has_many :microposts, dependent: :destroy

  # follwer, follwered
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
inverse_of: :follower

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy,
inverse_of: :followed

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  ## 書き方をメソッド参照に変更
  before_save :downcase_email # メールアドレスを事前に小文字に直す
  before_create :create_activation_digest
  # 括弧で括ったりもできるっぽい
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:name, presence: true, length: { minimum: 0, maximum: 50 })

  validates :email,
            presence:   true,
            length:     {
              minimum: 0,
              maximum: 255
            },
            format:     {
              with: VALID_EMAIL_REGEX
            }, ## *@*.com
            uniqueness: true ## 一意

  # password, password_digestがmodelに含まれる
  # + authenticateメソッドが使えるようになる。
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 現在のユーザーが他のユーザーをフォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  ## 永続セッションのためにユーザをデータベースに記憶
  def remember
    self.remember_token = User.new_token # ローカル変数にはせずインスタンス変数
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    # sendメソッドはメソッドテキストでcallできるやつ
    # よく見る
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    User.inspect(token, digest)
  end

  ## ログイン情報の破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  ## セッションハイジャックの防止のためのセッショントークンを返す
  def session_token
    remember_digest || remember
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  ## 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  ## パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    # self.update_attribute(:reset_digest,  User.digest(reset_token))
    # self.update_attribute(:reset_sent_at, Time.zone.now)
    ## validationがかからないらしいから注意
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  ## パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    # 同じ変数を複数の場所に差し込む場合は、key, valueで書くと良い
    # following_ids = "SELECT followed_id FROM relationships
    #                 WHERE  follower_id = :user_id"
    # Micropost.where("user_id IN (#{following_ids})
    #              OR user_id = :user_id", user_id: id)
    #              .includes(:user, image_attachment: :blob)
    # #Micropost.where("user_id = ?", id) # = microposts

    # ↓

    part_of_feed = 'relationships.follower_id = :id or microposts.user_id = :id'

    ## distinctで重複項目の削除
    Micropost
      .left_outer_joins(user: :followers)
      .where(part_of_feed, { id: })
      .distinct
      .includes(:user, image_attachment: :blob)
  end

  private

  ## メールアドレスをすべて小文字にする
  def downcase_email
    # self.email = email.downcase
    email.downcase!
  end

  ## 有効化トークンとダイジェストを作成及び代入する
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
