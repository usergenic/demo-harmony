Given "the following HTML is loaded" do |html|
    new_page(html)
end

Given /the Javascript file "(.*)" is loaded/ do |filename|
    page.load(javascript_path(filename))
end

When "the following Javascript is run" do |javascript|
    page.execute_js("__result__=(#{javascript})")
end

Then /the Javascript result should be (.*)/ do |expected_result|
    last_run.should == eval(expected_result)
end

Then "the HTML should be" do |html|
    page.to_html.should == html
end

Then /the content of "(.*)" should match$/ do |selector, content|
    Hpricot(page.to_html).search(selector).to_s.should == content
end

Then /the content of "(.*)" should match "(.*)"/ do |selector, content|
    Hpricot(page.to_html).search(selector).innerHTML.to_s.should == content
end
