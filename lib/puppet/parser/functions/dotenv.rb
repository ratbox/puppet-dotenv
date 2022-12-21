# Function: dotenv

module Puppet::Parser::Functions
  newfunction(:dotenv, type: :rvalue, doc: <<-EOS
Convert a Puppet hash into a dotenv-format file contents string
EOS
             ) do |argv|

    if argv.empty? || !argv[0].is_a?(Hash)
      raise(Puppet::ParseError, 'dotenv(): requires a hash argument')
    end
    if argv.size > 1
      raise(Puppet::ParseError, 'dotenv(): too many arguments')
    end

    lines = []
    lines << '# Managed by Puppet' << nil

    argv[0].each do |key, val|
      if defined?(val)
        case val
        when TrueClass
          lines << "#{key}=true"
        when FalseClass
          lines << "#{key}=false"
        when Fixnum
          lines << "#{key}=#{val}"
        else
          lines << "#{key}=\"#{val}\""
        end
      else
        lines << "#{key}=null"
      end
    end

    lines << nil
    return lines.join("\n")
  end
end

# vim: ts=2 sw=2 et
