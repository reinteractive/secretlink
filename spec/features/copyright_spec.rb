require "rails_helper"

describe 'Copyright', type: :feature do
  let(:permission_text) do
    'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, and distribute copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:'
  end
  let(:permission_text1) do
    "a) The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."
  end

  let(:permission_text2) do
    "b) The software is not used to commercially compete with the service provided at https://SecretLink.org/"
  end

  let(:permission_text3) do
    'c) THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'
  end

  it 'provides copyright information' do
    visit copyright_path
    expect(page).to have_content("Copyright #{Time.zone.now.to_date.year} reinteractive Pty Ltd.")
    expect(page).to have_content(permission_text)
    expect(page).to have_content(permission_text1)
    expect(page).to have_content(permission_text2)
    expect(page).to have_content(permission_text3)
  end
end
