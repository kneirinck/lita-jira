# lita-jira plugin
module Lita
  # Because we can.
  module Handlers
    # Main handler
    class Jira < Handler
      namespace 'Jira'

      config :username, required: true
      config :password, required: true
      config :site, required: true
      config :context, required: true

      include ::JiraHelper::Issue
      include ::JiraHelper::Misc
      include ::JiraHelper::Regex

      route(
        /^jira\s#{ISSUE_PATTERN}$/,
        :summary,
        command: true,
        help: {
          t('help.summary.syntax') => t('help.summary.desc')
        }
      )

      route(
        /^jira\sdetails\s#{ISSUE_PATTERN}$/,
        :details,
        command: true,
        help: {
          t('help.details.syntax') => t('help.details.desc')
        }
      )

      route(
        /^jira\scomment\son\s#{ISSUE_PATTERN}\s#{COMMENT_PATTERN}$/,
        :comment,
        command: true,
        help: {
          t('help.comment.syntax') => t('help.comment.desc')
        }
      )

      route(
        /^jira\screate\s#{TYPE_PATTERN}\s(for\s)?#{PROJECT_PATTERN}\s#{SUMMARY_PATTERN}(\s#{DESCRIPTION_PATTERN})?(\s#{COMPONENTS_PATTERN})?(\s#{PRIORITY_PATTERN})?$/,
        :todo,
        command: true,
        help: {
          t('help.todo.syntax') => t('help.todo.desc')
        }
      )

      def summary(response)
        issue = fetch_issue(response.match_data['issue'])
        return response.reply(t('error.request')) unless issue
        response.reply(t('issue.summary', key: issue.key, summary: issue.summary, url: config.site + 'browse/' + issue.key))
      end

      def details(response)
        issue = fetch_issue(response.match_data['issue'])
        return response.reply(t('error.request')) unless issue
        response.reply(format_issue(issue))
      end

      def comment(response)
        issue = fetch_issue(response.match_data['issue'])
        return response.reply(t('error.request')) unless issue
        comment = issue.comments.build
        comment.save!(body: response.match_data['comment'])
        response.reply(t('comment.added', issue: issue.key))
      end

      def todo(response)
        issue = create_issue(response.match_data['project'],
                             response.match_data['type'],
                             response.match_data['summary'],
                             response.match_data['description'],
                             response.user.metadata['mention_name'],
                             response.match_data['components'],
                             response.match_data['priority'])
        return response.reply(t('error.request')) unless issue
        response.reply(t('issue.created', key: issue.key))
      end

      Lita.register_hook(:before_run, -> (payload) do
        ConfigurationBuilder.load_user_config(payload[:config_path])
        route Regexp.new("#{Lita.config.handlers.jira.site}browse/#{ISSUE_PATTERN}"), :details
      end)
    end

    Lita.register_handler(Jira)
  end
end
