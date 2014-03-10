class DeployController < ApplicationController
  def show_deploy_api
    @action = deploy_do_deploy_api_path
  end

  def show_deploy_ui
    @action = deploy_do_deploy_ui_path
    @commits = ui_last_commits
  end

  def do_deploy_api
    do_deploy 'api'
  end

  def do_deploy_ui
    do_deploy 'ui'
  end

  private

  def ui_last_commits
    commit_objects = Octokit.commits(Deployer.config.ui_repo) rescue []
    commits = commit_objects.first(3).map do |c|
      { author: c.commit.author.name, date: c.commit.author.date,
        message: c.commit.message, sha: c.sha.first(8) }
    end
  end

  def do_deploy(service)
    deploy_uid = DeployTool.deploy(service)

    if deploy_uid
      render json: { deploy_uid: deploy_uid, status: 'ok' }
    else
      last_deploy = Deploy.where(service: service, state: 'in_progress').last
      last_deploy ? render(json: { deploy_uid: last_deploy.uid, status: 'already_running' }) : head(:bad_request)
    end
  end
end
