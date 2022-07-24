require './logic/file_reader'

describe FileReader do
  context 'sunny path' do
    let(:file_path) do
      './spec/samples/empty_radar.txt'
    end

    subject do
      described_class.new.read(file_path)
    end

    it 'it chomps endline characters' do
      expect(subject).to eq(["----", "----", "----", "----"])
    end
  end

  context 'File loading error' do
    let(:file_path) do
      './spec/samples/nonexistingfile'
    end

    subject do
      described_class.new.read(file_path)
    end

    it 'it chomps endline characters' do
      expect { subject }.to raise_error("Cannot load file: #{file_path}")
    end
  end
end
