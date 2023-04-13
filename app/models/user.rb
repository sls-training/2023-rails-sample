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
    
    attr_accessor :remember_token, :activation_token, :reset_token
    
    ## 書き方をメソッド参照に変更
    before_save :downcase_email # メールアドレスを事前に小文字に直す
    before_create :create_activation_digest
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
        length: {minimum: 6},
        allow_nil: true
    
    ## 永続セッションのためにユーザをデータベースに記憶
    def remember
        self.remember_token = User.new_token #ローカル変数にはせずインスタンス変数
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest
    end
    
    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(attribute, token)
        # sendメソッドはメソッドテキストでcallできるやつ
        # よく見る
        digest = self.send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
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
        self.update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    ## パスワード再設定のメールを送信する
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    
    private
        ## メールアドレスをすべて小文字にする
        def downcase_email
            #self.email = email.downcase
            self.email.downcase!
        end
        
        ## 有効化トークンとダイジェストを作成及び代入する
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
