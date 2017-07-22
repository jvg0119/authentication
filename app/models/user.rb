class User < ApplicationRecord

  before_save { self.email = email.downcase if email.present? }
  before_save :format_name

  validates :name, presence: true, length: { minimum: 3, maximum: 20 }
  validates :email,
            presence: true,
  			    format: { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ },
  			    uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true
  #validates :password_confirmation, presence: true

  has_secure_password

  def format_name
    # self.name = self.name.split.map{|name| name.capitalize}.join(' ') if name.present? # OK

    if name
      name_array =[]
      self.name.split.each do |n|
        name_array << n.capitalize
      end
      self.name = name_array.join(' ')
    end
  end

end
