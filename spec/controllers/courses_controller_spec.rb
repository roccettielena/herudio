require 'rails_helper'

RSpec.describe CoursesController do
  describe "GET 'index'" do
    let!(:course) { FactoryGirl.create(:course) }

    it 'loads the courses' do
      get :index
      expect(assigns(:courses)).to eq([course])
    end

    context "when the 'by_name' param is specified'" do
      let!(:matching_course) { FactoryGirl.create(:course, name: 'Foocourse') }
      let!(:nonmatching_course) { FactoryGirl.create(:course, name: 'Barcourse') }

      it 'loads only the matching courses' do
        get :index, by_name: 'foo'
        expect(assigns(:courses)).to eq([matching_course])
      end
    end

    context "when the 'by_category' param is specified'" do
      let!(:matching_course) { FactoryGirl.create(:course) }
      let!(:nonmatching_course) { FactoryGirl.create(:course) }

      it 'loads only the matching courses' do
        get :index, by_category: matching_course.category.id
        expect(assigns(:courses)).to eq([matching_course])
      end
    end
  end

  describe "GET 'show'" do
    context 'when the course exists' do
      let!(:course) { FactoryGirl.create(:course) }

      it 'loads the course' do
        get :show, id: course.id
        expect(assigns(:course)).to eq(course)
      end
    end

    context 'when the course does not exist' do
      it 'raises an error' do
        expect {
          get :show, id: 1
        }.to raise_error
      end
    end
  end
end
