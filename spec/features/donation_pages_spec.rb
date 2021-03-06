#
# Integration tests for Donation pages
#

RSpec.describe 'donation', :js do
  subject { page }

  describe 'shows a flattr button' do
    before do
      visit root_path
      click_link t('layouts.header.donate')
    end

    it 'shows flattr button' do
      expect(page).to have_selector(:xpath, "//iframe[@title='Flattr']")
    end
  end

  describe 'allows users to contribute to our cause' do
    before do
      visit new_donation_path
      select '20', from: 'donation[amount]'
      click_button t('helpers.submit.donation.create')

      expect { Donation.count }.to become(1)
    end

    context 'when successful donation' do
      before { mock_paypal_pdt('SUCCESS', Donation.last.id) }

      it 'shows a success flash message' do
        expect(page).to \
          have_flash_message t('donations.create.success'), 'success'
      end
    end

    context 'when unsuccessful donation' do
      before { mock_paypal_pdt('FAIL', Donation.last.id) }

      it 'shows an error flash message' do
        expect(page).to have_flash_message t('donations.create.error'), 'error'
      end
    end
  end
end
