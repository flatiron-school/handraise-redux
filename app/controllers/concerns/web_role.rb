module WebRole
  def successful_login_path
    if admin?
      :issues
    else
      self
    end
  end
end

