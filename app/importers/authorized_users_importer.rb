class AuthorizedUsersImporter
  include CSVImporter

  model AuthorizedUser

  column :first_name,
    as: ['NOME'],
    to: -> (first_name) { first_name.strip },
    required: true

  column :last_name,
    as: ['COGNOME'],
    to: -> (last_name) { last_name.strip },
    required: true

  column :group,
    as: ['CLASSE'],
    to: -> (group) { UserGroup.find_or_create_by name: group.gsub(' ', '') },
    required: true

  column :birth_date,
    as: ['DATA DI NASCITA (GG/MM/AAAA)']

  column :birth_location,
    to: -> (birth_location) { birth_location.strip },
    as: ['LUOGO DI NASCITA']

  identifier :group, :first_name, :last_name

  when_invalid :skip
end
