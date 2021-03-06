require 'spec_helper'

describe UsernameCheckerService do

  describe 'check_username' do

    before do
      @service = UsernameCheckerService.new
      @nil_email = nil
      @email = 'vincentvega@example.com'
    end

    context 'Username invalid' do
      it 'rejects too short usernames' do
        result = @service.check_username('a', @nil_email)
        expect(result).to have_key(:errors)
      end
      it 'rejects too long usernames' do
        result = @service.check_username('a123456789b123456789c123456789', @nil_email)
        expect(result).to have_key(:errors)
      end

      it 'rejects usernames with invalid characters' do
        result = @service.check_username('vincent-', @nil_email)
        expect(result).to have_key(:errors)
      end

      it 'rejects usernames that do not start with an alphanumeric character' do
        result = @service.check_username('_vincent', @nil_email)
        expect(result).to have_key(:errors)
      end
    end

    it 'username not available locally' do
      User.stubs(:username_available?).returns(false)
      UserNameSuggester.stubs(:suggest).returns('einar-j')
      result = @service.check_username('vincent', @nil_email)
      result[:available].should == false
      result[:suggestion].should eq('einar-j')
    end

    it 'username available locally' do
      User.stubs(:username_available?).returns(true)
      result = @service.check_username('vincent', @nil_email)
      result[:available].should == true
    end
  end

end
