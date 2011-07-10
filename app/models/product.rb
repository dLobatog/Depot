class Product < ActiveRecord::Base
  default_scope :order => 'title'
  
  # ------------------ Relations -------------------------------
  has_many :line_items #Not dependent - if a line_item is deleted, its correspondant product does not need to be destroyed from the database
  before_destroy :ensure_not_referenced_by_any_line_item
  
  # ------------------ Validations -----------------------------
  validates :title, :description, :image_url, :presence => true 
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with => %r{\.(gif|jpg|png)$}i,
    :message => 'must be a URL for GIF, JPG or PNG image.'
  }
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
    
  private
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line items present')
      return false
    end
  end
end
