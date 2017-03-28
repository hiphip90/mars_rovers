require_relative '../../lib/mission_control'
require_relative '../../lib/rover'
require_relative '../../lib/rover/guidance_unit'

describe Rover::GuidanceUnit do
  let(:mission_control) { double(MissionControl) }
  let(:rover) { double(Rover, id: 1) }
  let(:guidance_unit) { Rover::GuidanceUnit.new(mission_control, rover) }

  context 'instance methods' do
    describe '#valid_destination?' do
      it 'delegates to mission_control passing given coordinates and attached rover id' do
        expect(mission_control).to receive(:tile_free?).with(0, 0, 1)

        guidance_unit.valid_destination?(0, 0)
      end

      it 'returns true if tile_free? returns true' do
        allow(mission_control).to receive(:tile_free?).with(0, 0, 1).and_return(true)

        expect(guidance_unit.valid_destination?(0, 0)).to be_truthy
      end

      it 'returns false if tile_free? returns false' do
        allow(mission_control).to receive(:tile_free?).with(0, 0, 1).and_return(false)

        expect(guidance_unit.valid_destination?(0, 0)).to be_falsey
      end
    end

    describe '#move_ahead' do
      it 'returns given coords with y increased by 1 when heading is N' do
        expect(guidance_unit.move_ahead(5, 5, 'N')).to eq [5, 6, 'N']
      end

      it 'returns given coords with y decreased by 1 when heading is S' do
        expect(guidance_unit.move_ahead(5, 5, 'S')).to eq [5, 4, 'S']
      end

      it 'returns given coords with y decreased by 1 when heading is S' do
        expect(guidance_unit.move_ahead(5, 5, 'E')).to eq [6, 5, 'E']
      end

      it 'returns given coords with y decreased by 1 when heading is S' do
        expect(guidance_unit.move_ahead(5, 5, 'W')).to eq [4, 5, 'W']
      end
    end


    describe '#turn_clockwise' do
      it 'returns given coords with heading changes to the next clockwise value' do
        headings = %w(N E S W)
        headings.each.with_index do |heading, i|
          next_heading = headings[(i + 1) % 4]
          expect(guidance_unit.turn_clockwise(0, 0, heading)).to eq [0, 0, next_heading]
        end
      end
    end

    describe '#turn_counterclockwise' do
      it 'returns given coords with heading changes to the next clockwise value' do
        headings = %w(N W S E)
        headings.each.with_index do |heading, i|
          next_heading = headings[(i + 1) % 4]
          expect(guidance_unit.turn_counterclockwise(0, 0, heading)).to eq [0, 0, next_heading]
        end
      end
    end
  end
end
