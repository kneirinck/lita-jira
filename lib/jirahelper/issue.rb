# Helper functions for lita-jira
module JiraHelper
  # Issues
  module Issue
    def fetch_issue(key)
      client.Issue.find(key)
      rescue
        log.error('JIRA HTTPError')
        nil
    end

    def fetch_project(key)
      client.Project.find(key)
      rescue
        log.error('JIRA HTTPError')
        nil
    end

    def format_issue(issue)
      t('issue.details',
        key: issue.key,
        summary: issue.summary,
        assigned: issue.assignee ? issue.assignee.displayName : 'Unassigned',
        priority: issue.priority.name,
        status: issue.status.name,
        url: config.site + 'browse/' + issue.key)
    end

    def create_issue(project, type, summary, description, reporter)
      issue = client.Issue.build
      issue.save(fields: { summary: summary,
                           description: description,
                           project: { key: project },
                           issuetype: { name: type.capitalize },
                           reporter: { name: reporter } })
      issue.fetch
      issue
    end
  end
end
