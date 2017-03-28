require_relative '../../lib/rover'
require_relative '../../lib/rover/control_unit'
require_relative '../../lib/rover/guidance_unit'
require_relative '../../lib/rover/chassis'

describe Rover::ControlUnit do
  let(:rover) { double(Rover, x: 0, y: 0, id: 1) }
  let(:guidance_unit) { double(Rover::GuidanceUnit) }
  let(:chassis) { double(Rover::Chassis) }
  let(:control_unit) { Rover::ControlUnit.new(rover, chassis, guidance_unit) }

  before do
    allow(guidance_unit).to receive(:valid_destination?).with(5, 5).and_return(true)
    allow(guidance_unit).to receive(:valid_destination?).with(1, 2).and_return(false)
  end

  context 'instance methods' do
    describe '#execute_command' do
      context 'when given coordinates' do
        it 'invokes call to #move_to on chassis with given coords' do
          expect(chassis).to receive(:move_to).with(5, 5, nil)

          control_unit.execute_command('5 5')
        end

        it 'invokes call to #move_to on chassis with given coords and heading' do
          expect(chassis).to receive(:move_to).with(5, 5, 'E')

          control_unit.execute_command('5 5 E')
        end

        it 'invokes report_obstructed if destination is not valid' do
          expect(control_unit).to receive(:report_obstructed)

          control_unit.execute_command('1 2')
        end
      end
    end
  end
end
