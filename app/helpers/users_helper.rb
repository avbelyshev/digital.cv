module UsersHelper
  def user_show(user)
    return user.name if user.name
    user.email
  end
end
