require './app'

# simple smoke test only to check if the app works
# class collaborators are tested separately

describe App do
  let(:file_reader) { double }
  let(:data_parser) { double }
  let(:test_finder) { double }
  let(:sample_path) { 'path.txt' }
  let(:sample_file_data) { '---\n-o-' }
  let(:sample_map) do
    data = MapData.new
    data.width = 1
    data.height = 2
    data.lines = ['-', 'o']
    data
  end

  subject { described_class.new(file_reader: file_reader, data_parser: data_parser) }

  describe '#run' do
    it 'does not raise error' do
      puts 'Smoke test'
      allow(file_reader).to receive(:read).with(sample_path) { sample_file_data }
      allow(data_parser).to receive(:parse).with(sample_file_data) { sample_map }
      expect(test_finder).to receive(:find).with(sample_map, sample_map) { [] }
      allow(test_finder).to receive(:label) { 'test_finder' }
      subject.init_radar_from_path(sample_path)
      subject.add_invader_from_path(sample_path)
      subject.add_finder(test_finder)
      expect { subject.run }.to_not raise_error
    end
  end
end
