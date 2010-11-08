# encoding: utf-8

class Hash
  def extended
    name = self[:name].gsub(/radiant-(.*)-extension/, '\1')
    len = name.length
"-- #{name} #{'-' * (68 - len)}
   #{(self[:url])[0...69]}

#{(self[:description]).wrap(69, 3)}
   INSTALL: ray add #{name}
\n"
  end
  def truncated
    name = self[:name].gsub(/radiant-(.*)-extension/, '\1')
    "** #{name}: #{(self[:description])[0...((72 - name.length) - 8)]}...
   Details: ray info #{name}
   Install: ray add #{name}
\n"
  end
end
