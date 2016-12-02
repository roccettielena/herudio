# frozen_string_literal: true
require 'open-uri'

class UsersImportingService
  def perform(url)
    CSV.new(open(url), headers: :first_row).each do |row|
      User.invite!(
        full_name: "#{row['NOME']} #{row['COGNOME']}",
        email: row['EMAIL'],
        group: UserGroup.find_or_create_by(name: "#{row['SEZIONE']}#{row['CLASSE']}")
      ) do |u|
        u.skip_invitation = true
      end
    end
  end
end
