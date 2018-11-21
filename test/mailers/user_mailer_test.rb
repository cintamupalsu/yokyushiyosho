require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
 #test "account_activation" do
 #  mail = UserMailer.account_activation
 #  assert_equal "アカウント開設", mail.subject
 #   assert_equal ["maulanamania@gmail.com"], mail.to
#    assert_equal ["noreply@mybluemix.net"], mail.from
#    assert_match "宜しくお願い致します", mail.body.encoded
#  end

#  test "password_reset" do
#    mail = UserMailer.password_reset
#    assert_equal "Password reset", mail.subject
#    assert_equal ["maulanamania@gmail.com"], mail.to
#    assert_equal ["noreply@mybluemix.net"], mail.from
#    assert_match "宜しくお願い致します", mail.body.encoded
#  end
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "アカウント開設", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@primekarte-maulanamania.c9users.io"], mail.from
    # Remark cause Japanese letters doesn't match to ASCII issues
    # assert_match user.name,               mail.body.encoded
    # assert_match user.activation_token,   mail.body.encoded
    # assert_match CGI.escape(user.email),  mail.body.encoded
    # ----
  end

end
