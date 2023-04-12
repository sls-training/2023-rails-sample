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
            BCrypt::Password.create(string, cost: cost)
        end
        ## ランダムなトークンを生成
        def new_token
            SecureRandom.urlsafe_base64
        end
    end
    
    attr_accessor :remember_token
    ## メールアドレスを事前に小文字に直す
    before_save { self.email = email.downcase }
    #括弧で括ったりもできるっぽい
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates(:name, presence: true,  length: {minimum:0, maximum:50})

    validates :email, 
        presence: true, 
        length: {minimum:0, maximum:255}, 
        format: { with: VALID_EMAIL_REGEX}, ## *@*.com
        uniqueness: true                    ## 一意
    
    # password, password_digestがmodelに含まれる
    # + authenticateメソッドが使えるようになる。
    has_secure_password

    validates :password, 
        presence: true,
        length: {minimum: 6}
    
    
    ## 永続セッションのためにユーザをデータベースに記憶
    def remember
        self.remember_token = User.new_token #ローカル変数にはせずインスタンス変数
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
end
