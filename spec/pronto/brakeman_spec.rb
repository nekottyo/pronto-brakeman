require 'spec_helper'
require 'ostruct'

module Pronto
  describe Brakeman do
    let(:brakeman) { Brakeman.new(patches, nil) }

    describe '#run' do
      subject { brakeman.run }

      context 'patches are nil' do
        let(:patches) { nil }
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end
    end
  end
end
