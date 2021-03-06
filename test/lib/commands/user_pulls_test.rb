# frozen_string_literal: true

require 'test_helper'
require 'commands/user_pulls'
require 'entities/pull_request'

module Commands
  class UserPullsTest < Minitest::Test
    def subject
      @subject ||= UserPulls.new(pull_requests: pull_requests)
    end

    def pull_requests
      @pull_requests ||= stub('data_source.pull_requests')
    end

    def pull_entity
      @pull_entity ||= Entities::PullRequest.new
    end

    def test_calls_pull_requests_data_source
      pull_requests.expects(:user_pulls).returns([])
      subject.call([])
    end

    def test_fuzzy_filters_pulls_title
      pull1 = Entities::PullRequest.new(title: 'foo bar-baz')
      pull2 = Entities::PullRequest.new(title: 'hello-world')
      pull_requests.expects(:user_pulls).returns([pull1, pull2])
      actual = subject.call(%w[fobz])
      expected = JSON.generate(items: [pull1.as_alfred_item])
      assert_equal expected, actual
    end

    def test_fuzzy_filters_pulls_html_url
      pull1 = Entities::PullRequest.new(html_url: 'foo bar-baz')
      pull2 = Entities::PullRequest.new(html_url: 'hello-world')
      pull_requests.expects(:user_pulls).returns([pull1, pull2])
      actual = subject.call(%w[fobz])
      expected = JSON.generate(items: [pull1.as_alfred_item])
      assert_equal expected, actual
    end

    def test_returns_alfred_items_json
      pull_requests.expects(:user_pulls).returns([pull_entity])
      actual = subject.call([])
      expected = JSON.generate(items: [pull_entity.as_alfred_item])
      assert_equal expected, actual
    end
  end
end
