class Query < ApplicationRecord
  belongs_to :visitor

  def self.record(q, visitor)
    query = visitor.queries.where(created_at: (3.seconds.ago..Time.now)).order('created_at DESC').first_or_initialize
    query.key = q
    query.save
  end
end
