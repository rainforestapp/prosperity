require 'spec_helper'

module Prosperity
  describe MetricFinder do
    subject { MetricFinder.new File.join(TEST_FILES, "metrics") }

    describe "#metrics" do
      let(:metrics) { subject.metrics }

      it "returns an array" do
        metrics.should be_an(Array)
      end

      it "should contain at least one metric" do
        metrics.size.should be > 0
        metrics.first.superclass.should == Metric
      end
    end

    describe ".find_by_name" do
      it "finds a metric by name" do
        metric = described_class.find_by_name('UsersMetric')
        metric.should be < Metric
      end
    end
  end
end
