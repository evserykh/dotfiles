require 'irb/ext/save-history'
require 'irb/completion'

IRB.conf[:SAVE_HISTORY] = 1000

def try_hirb
  begin
    require 'hirb'
    Hirb.enable
  rescue LoadError
    warn 'Unable to load hirb'
  end
end

def try_pry
  begin
    require 'pry'
    Pry.start
    exit
  rescue LoadError
    warn 'Unable to load pry'
  end
end

try_pry
try_hirb
