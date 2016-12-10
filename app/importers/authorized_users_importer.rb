class AuthorizedUsersImporter
  include CSVImporter

  model AuthorizedUser

  column :first_name,
    as: ['NOME'],
    required: true

  column :last_name,
    as: ['COGNOME'],
    required: true

  column :group,
    as: ['CLASSE'],
    to: -> (group) { UserGroup.find_or_create_by name: group.gsub(' ', '') },
    required: true

  column :birth_date,
    as: ['DATA DI NASCITA (GG/MM/AAAA)']

  column :birth_location,
    as: ['LUOGO DI NASCITA']

  identifier :group, :first_name, :last_name

  when_invalid :skip
end
