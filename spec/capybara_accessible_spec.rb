require 'spec_helper'

describe 'capybara-accessible' do
  shared_examples 'a capybara accessible driver' do
    before do
      @session = Capybara::Session.new(driver_name, AccessibleApp)
    end

    context 'a page without accessibility errors' do
      it 'does not raise an exception on audit failures' do
        expect { @session.visit('/accessible') }.to_not raise_error
      end
    end

    context 'a page with inaccessible elements' do
      it 'raises an exception on visiting the page' do
        expect { @session.visit('/inaccessible') }.to raise_error(Capybara::Accessible::InaccessibleError)
      end

      it 'raises an exception when visiting the page via a link' do
        @session.visit('/accessible')
        expect { @session.click_link('inaccessible') }.to raise_error(Capybara::Accessible::InaccessibleError)
      end

      context 'with configuration that excludes rules' do
        before do
          Capybara::Accessible::Auditor.exclusions = ['AX_TEXT_01']
        end

        it 'does not raise an error on an excluded rule' do
          expect { @session.visit('/excluded') }.to_not raise_error
        end
      end

      context 'with log level set to warn' do
        before do
          Capybara::Accessible::Auditor.log_level = :warn
        end

        after do
          Capybara::Accessible::Auditor.log_level = :error
        end

        it 'puts to stdout and does not raise an error' do
          expect($stdout).to receive(:puts)
          expect { @session.visit('/inaccessible') }.to_not raise_error
        end
      end

      context 'a page with a javascript popup' do
        it 'does not raise an exception' do
          @session.visit('/alert')
          expect { @session.click_link('Alert!') }.to_not raise_error
        end
      end

      context 'with severity set to severe' do
        before do
          Capybara::Accessible::Auditor.severe_rules = ['AX_TEXT_02']
        end

        after do
          Capybara::Accessible::Auditor.severe_rules = []
        end

        it 'raises an exception on the image without alt text' do
          expect { @session.visit('/severe') }.to raise_error(Capybara::Accessible::InaccessibleError)
        end
      end
    end
  end

  describe 'poltergeist driver' do
    let(:driver_name) { :accessible_poltergeist }
    it_behaves_like 'a capybara accessible driver'
  end

  describe 'selenium driver' do
    let(:driver_name) { :accessible_selenium }
    it_behaves_like 'a capybara accessible driver'
  end

  describe 'webkit driver' do
    let(:driver_name) { :accessible_webkit }
    it_behaves_like 'a capybara accessible driver'
  end
end
