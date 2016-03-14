# Helper functions for lita-jira
module JiraHelper
  # Regular expressions
  module Regex
    QUOTE_PATTERN = /[\"“”]/
    TYPE_PATTERN = /(?<type>\w+)/
    COMMENT_PATTERN = /#{QUOTE_PATTERN}(?<comment>.+)#{QUOTE_PATTERN}/
    DESCRIPTION_PATTERN = /#{QUOTE_PATTERN}(?<description>.+?)#{QUOTE_PATTERN}/m
    SUMMARY_PATTERN = /#{QUOTE_PATTERN}(?<summary>.+?)#{QUOTE_PATTERN}/m
    PROJECT_PATTERN = /(?<project>[a-zA-Z0-9]{1,10})/
    ISSUE_PATTERN   = /(?<issue>#{PROJECT_PATTERN}-[0-9]{1,5}+)/
    EMAIL_PATTERN   = /(?<email>[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+)/i
    COMPONENTS_PATTERN = /-component(s)\s#{QUOTE_PATTERN}?(?<components>[\w\,]+)#{QUOTE_PATTERN}?/
    PRIORITY_PATTERN = /-priority\s#{QUOTE_PATTERN}?(?<priority>\w+)#{QUOTE_PATTERN}?/
    ASSIGNEE_PATTERN = /-assign(ee)?\s#{QUOTE_PATTERN}?(?<assignee>(\w+\.\w+))#{QUOTE_PATTERN}?/
  end
end
