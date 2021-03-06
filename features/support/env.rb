require 'fileutils'
require 'rr'
require 'test/unit'

TEST_DIR    = File.join('/', 'tmp', 'jekyll')
JEKYLL_PATH = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'jekyll')

def run_jekyll(opts = {})
  command = JEKYLL_PATH.clone
  command << " build"
  command << " --drafts" if opts[:drafts]
  command << " >> /dev/null 2>&1" if opts[:debug].nil?
  system command
end

def time_format(date)
  if has_time_component?(date)
    ['%Y-%m-%d %H:%M %z'] * 2
  else
    ['%m/%d/%Y', '%Y-%m-%d %H:%M']
  end
end

def has_time_component?(date_string)
  date_string.split(" ").size > 1
end

def slug(title)
  title.downcase.gsub(/[^\w]/, " ").strip.gsub(/\s+/, '-')
end

def location(folder, direction)
  if folder
    before = folder if direction == "in"
    after = folder if direction == "under"
  end
  [before || '.', after || '.']
end

# work around "invalid option: --format" cucumber bug (see #296)
Test::Unit.run = true if RUBY_VERSION < '1.9'
