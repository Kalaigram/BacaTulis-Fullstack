module ApplicationHelper
  def nav_link_to(name, path, **options)
    options[:class] = [ options[:class], current_page?(path) ? "menu-active" : nil ].compact.join(" ").presence
    link_to name, path, **options
  end
end
