require './logic/bottom_edge_finder'
require './logic/data_parser'
require './models/map_data'
require './models/vector'

describe BottomEdgeFinder do
  let(:invader) do
    DataParser.new.parse(
      [
        '--o--',
        '-ooo-',
        'ooooo',
        '-ooo-',
        '--o--',
      ]
    )
  end

  let(:noise_level_threshold) { 0 }
  let(:max_roll_down) { 2 }

  subject do
    described_class.new(radar, noise_level_threshold, max_roll_down).find(invader)
  end

  context 'radar is clear' do
    context 'invader is partially present' do
      let(:radar) do
        DataParser.new.parse(
          [
            '-------',
            '-------',
            '---o---',
            '--ooo--',
            '-ooooo-',
          ]
        )
      end

      it 'contains the exact match in results' do
        expect(subject).to eq([Vector.new(1, 2)])
      end
    end

    context 'invader is partially present' do
      let(:radar) do
        DataParser.new.parse(
          [
            '-------',
            '---o---',
            '--ooo--',
            '-ooooo-',
            '--ooo--',
          ]
        )
      end

      it 'contains the exact match in results' do
        expect(subject).to eq([Vector.new(1, 1)])
      end
    end

    context 'invader is partially present in the middle' do
      let(:radar) do
        DataParser.new.parse(
          [
            '--------',
            '----o---',
            '---ooo--',
            '--ooooo-',
            '--------',
          ]
        )
      end

      it 'does not match' do
        expect(subject).to be_empty
      end
    end

    context 'invader too small' do
      let(:radar) do
        DataParser.new.parse(
          [
            '--------',
            '--------',
            '--------',
            '----o---',
            '---ooo--',
          ]
        )
      end

      it 'does not match' do
        expect(subject).to be_empty
      end
    end

    context 'no invader found' do
      let(:radar) do
        DataParser.new.parse(
          [
            '-------',
            '-------',
            '-------',
            '-------',
            '-------',
          ]
        )
      end

      it 'returns empty result' do
        expect(subject).to be_empty
      end
    end
  end

  context 'radar is noisy' do
    let(:radar) do
      DataParser.new.parse(
        [
          '--------',
          '--------',
          '-----o--',
          '----ooo-',
          '---oo--o',
        ]
      )
    end

    context 'exact match is required' do
      let(:noise_level_threshold) { 0 }
      it 'returns empty result' do
        expect(subject).to be_empty
      end
    end

    context 'and noise level allows one difference' do
      let(:noise_level_threshold) { 1 }
      it 'contains match in results' do
        expect(subject).to be_empty
      end
    end

    context 'and noise level allows two differences' do
      let(:noise_level_threshold) { 2 }
      it 'contains match in results' do
        expect(subject).to eq([Vector.new(3, 2)])
      end
    end
  end
end
