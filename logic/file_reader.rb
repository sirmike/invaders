class FileReader
  def read(file_path)
    return IO.readlines(file_path, chomp: true)
  rescue
    # it should be handled better, but it's just for tests simplicity
    raise "Cannot load file: #{file_path}"
  end
end
