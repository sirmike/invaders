require './logic/full_scan_finder'
require './logic/data_parser'
require './models/map_data'
require './models/vector'
require './models/radar'
require './models/invader'

describe FullScanFinder do
  let(:radar) do
    Radar.new(radar_data)
  end

  let(:invader_data) do
    DataParser.new.parse(
      [
        'oo',
        'oo'
      ]
    )
  end

  let(:invader) do
    Invader.new(invader_data)
  end

  let(:noise_level_threshold) { 0 }

  subject do
    described_class.new(radar, noise_level_threshold).find(invader)
  end

  context 'radar is clear' do
    context 'invader is present' do
      let(:radar_data) do
        DataParser.new.parse(
          [
            '--oo',
            '--oo',
            '----',
          ]
        )
      end

      it 'contains the exact match in results' do
        expect(subject).to eq([Vector.new(2, 0)])
      end
    end

    context 'no invader found' do
      let(:radar_data) do
        DataParser.new.parse(
          [
            '----',
            '----',
            '----',
          ]
        )
      end

      it 'returns empty result' do
        expect(subject).to be_empty
      end
    end
  end

  context 'radar is noisy' do
    let(:radar_data) do
      DataParser.new.parse(
        [
          'oo--',
          'o---',
          '-o--',
        ]
      )
    end

    context 'exact match is required' do
      it 'returns empty result' do
        expect(subject).to be_empty
      end
    end

    context 'and noise level allows one difference' do
      let(:noise_level_threshold) { 1 }
      it 'contains match in results' do
        expect(subject).to eq([Vector.new(0, 0)])
      end
    end

    context 'noise level allows two differences' do
      let(:noise_level_threshold) { 2 }
      it 'contains two matches' do
        expect(subject).to eq(
          [
            Vector.new(0, 0),
            Vector.new(0, 1)
          ]
        )
      end
    end
  end
end
