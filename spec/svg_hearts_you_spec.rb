require 'spec_helper'

RSpec.describe SvgHeartsYou do

  let(:test_svg_path) { File.join(File.dirname(__FILE__), 'svgs') }

  let!(:svg_file)             { 'sapphire.svg' }
  let!(:nonexistant_svg_file) { 'nope-nope-nope.svg' }
  let!(:unconfigured_message) { 'svg_path is not set' }
  let!(:missing_file_message) { "File #{nonexistant_svg_file} not found" }

  shared_examples 'method that needs module configuration' do |method|
    it 'throws a RuntimeError when not configured' do
      expect{subject.send(method, svg_file)}.to raise_error(RuntimeError, unconfigured_message)
    end
  end

  shared_examples 'method using file' do |method|
    it 'throws a RuntimeError when file is not found' do
      expect{subject.send(method, nonexistant_svg_file)}.to raise_error(RuntimeError, missing_file_message)
    end
  end

  shared_examples 'svg use' do
    it 'returns SVG use statement' do
      svg_content = subject.svg_use 'id'
      expect(svg_content).to include '<use xlink:href="#id">'
    end

    it 'adds classes and ids to svg tag' do
      svg_content = subject.svg_use 'id', id: 'hearts', class: 'love'
      expect(svg_content).to have_tag('svg', with: { id: 'hearts', class: 'love' })
    end

    it 'adds any attribute to svg tag' do
      attributes = { width: '64px', height: '48px', viewport: '0, 0, 12, 24' }
      svg_content = subject.svg_use 'id', attributes
      expect(svg_content).to have_tag('svg', with: attributes)
    end
  end

  describe 'module not configured' do
    describe 'self.configuration' do
      it 'not configured' do
        expect(SvgHeartsYou.configuration.svg_path).to be_nil
      end
    end

    describe '#svg_inline' do
      it_behaves_like 'method that needs module configuration', :svg_inline
    end

    describe '#svg_use' do
      include_examples 'svg use'
    end

    describe '#svg_symbol' do
      it_behaves_like 'method that needs module configuration', :svg_symbol
    end
  end


  describe 'module configured' do
    before do
      SvgHeartsYou.configure do |config|
        config.svg_path = test_svg_path
      end
    end

    describe 'self.configuration' do
      it 'is configured to the the current directory' do
        expect(SvgHeartsYou.configuration.svg_path).to eq(test_svg_path)
      end
    end

    describe '#svg_inline' do
      it_behaves_like 'method using file', :svg_inline

      it 'returns contents of SVG file without XML headers' do
        svg_content = subject.svg_inline 'sapphire.svg'

        expect(svg_content).to have_tag('svg')
        expect(svg_content).not_to include('<xml')
        expect(svg_content).not_to include('DOCTYPE')
      end
    end

    describe '#svg_use' do
      include_examples 'svg use'
    end

    describe '#svg_symbol' do
      let(:sapphire_svg_attributes) {{
        x: '0',
        y: '0',
        width: '64',
        height: '52',
        viewbox: '0, 0, 64, 52'
      }}

      it_behaves_like 'method using file', :svg_symbol

      it 'returns the SVG contents in a symbol' do
        svg_content = subject.svg_symbol svg_file

        expect(svg_content).not_to have_tag('svg', with: sapphire_svg_attributes)
        expect(svg_content).to have_tag('svg>symbol', with: sapphire_svg_attributes)
        expect(svg_content).to have_tag('svg>symbol', with: { id: 'sapphire' })
        expect(svg_content).not_to have_tag('svg>*:not(symbol)')
        expect(svg_content).to have_tag('svg>symbol>*')
      end
    end
  end
end
