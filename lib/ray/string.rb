# Additional methods for working with strings
class String
  def wrap col = 80, pad = 0
    # NOTE: text wrapping regular expression from http://goo.gl/dpIk
    self.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "#{' ' * pad}\\1\\3\n")
  end
end