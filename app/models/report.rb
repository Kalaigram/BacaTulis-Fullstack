class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reportable, polymorphic: true

  enum :status, { pending: 0, reviewed: 1, resolved: 2, dismissed: 3 }
  enum :reason, { spam: 0, inappropriate: 1, harassment: 2, other: 3 }

  validates :reason, presence: true
  validates :description, length: { maximum: 1000 }, allow_blank: true

  scope :pending_reports, -> { where(status: :pending).order(created_at: :desc) }
end
