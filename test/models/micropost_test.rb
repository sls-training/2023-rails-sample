require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)

    # ↓慣習に合わせて変更した
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  ###################################
  ## Micropostがバリデーション違反 ##
  ###################################

  test 'content should be present' do
    @micropost.content = '   '
    assert_not @micropost.valid?
  end

  test 'content should be at most 140 characters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  # 一番新しいやつかどうかを検証
  test 'order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
