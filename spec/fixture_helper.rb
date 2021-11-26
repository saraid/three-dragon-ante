require 'pathname'

def fixture(filename)
  Pathname.new("spec/fixtures/#{filename}")
end

def query_fixture(name)
  fixture("queries/#{name}.soql")
end
