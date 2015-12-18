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

    def create_issue(project, type, summary, description, reporter, components)
      issue = client.Issue.build
      jira_components = []
      if components.kind_of?(String)
        for component in components.split(%r{,\s*})
          jira_components.push({
            name: component
          })
        end
      end
      issue.save(fields: { summary: summary,
                           description: description.nil? ? "" : description,
                           project: { key: project },
                           issuetype: { name: type.capitalize },
                           reporter: { name: reporter },
                           components: jira_components })
      issue.fetch
      issue
    end
  end
end
