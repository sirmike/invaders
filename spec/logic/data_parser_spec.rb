require './logic/data_parser'
require './models/map_data'

describe DataParser do
  context 'sunny path' do
    let(:lines) do
      [
        '---',
        '-o-',
        '---'
      ]
    end

    subject do
      described_class.new.parse(lines)
    end

    it 'reads width' do
      expect(subject.width).to eq(3)
    end

    it 'reads height' do
      expect(subject.height).to eq(3)
    end

    it 'reads lines data' do
      expect(subject.lines).to eq(lines)
    end
  end

  context 'lines contain noisy characters' do
    let(:lines) do
      [
        '---',
        '-o-',
        '*--'
      ]
    end

    it 'parses it as well' do
      expect { subject.parse(lines) }.not_to raise_error
    end
  end

  context 'lines are empty' do
    let(:lines) do
      []
    end

    it 'raises an error' do
      expect { subject.parse(lines) }.to raise_error('Lines cannot be empty')
    end
  end

  context 'lines are not the same length' do
    let(:lines) do
      [
        '--',
        '-o-',
        '--'
      ]
    end

    it 'raises an error' do
      expect { subject.parse(lines) }.to raise_error('Lines must be the same length')
    end
  end
end
