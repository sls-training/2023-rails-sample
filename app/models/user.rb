## ApplicationRecordはActiveRecordを継承
## https://api.rubyonrails.org/v7.0/classes/ActiveRecord/Callbacks/ClassMethods.html#method-i-before_save
class User < ApplicationRecord
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

end
