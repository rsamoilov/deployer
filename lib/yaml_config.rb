class YamlConfig
  def initialize(file_path)
    @file_path = file_path
    @config = to_deep_ostruct(YAML.load_file(@file_path))
  end

  def method_missing(method_name, *args)
    @config.send method_name
  end

  private

  def to_deep_ostruct(hash)
    hash.each do |key, value|
      hash[key] = to_deep_ostruct(value) if value.is_a?(Hash)
    end

    OpenStruct.new hash
  end
end
