module Features
  module SessionHelpers
    def signin(email, password)
      visit root_path
      click_link I18n.t('layout.nav.sign_in')
      fill_in I18n.t('simple_form.labels.user.email'), with: email
      fill_in I18n.t('simple_form.labels.user.password'), with: password
      click_button I18n.t('devise.sessions.new.submit')
    end
  end
end
