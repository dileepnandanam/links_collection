class Ad < ApplicationRecord
  default_scope -> { where(hide: false)}
end
