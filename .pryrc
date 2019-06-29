# this is pry config file

# pry configure

Pry.config.pager = false

# util methods

def pbcopy(data)
  IO.popen 'pbcopy', 'w' do |io|
    io << data
  end

  data
end

def pbpaste
  `pbpaste`
end
