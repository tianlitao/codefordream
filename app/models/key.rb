# -*- encoding : utf-8 -*-
# gem 'settingslogic'
class Key < Settingslogic
  source "#{Rails.root}/config/key.yml"
  namespace Rails.env
end
