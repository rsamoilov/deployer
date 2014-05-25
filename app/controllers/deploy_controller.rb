class DeployController < ApplicationController
  def show_deploy_api
    @action = do_deploy_path('api')
  end

  def show_deploy_ui
    @action = do_deploy_path('ui')
    @commits = ui_last_commits
  end

  def show_deploy_collector
    @action = do_deploy_path('collector')
  end

  def do_deploy
    service = params[:service]
    deploy_uid = DeployTool.deploy(service)

    if deploy_uid
      render json: { deploy_uid: deploy_uid, status: 'ok' }
    else
      last_deploy = Deploy.where(service: service, state: 'in_progress').last
      last_deploy ? render(json: { deploy_uid: last_deploy.uid, status: 'already_running' }) : head(:bad_request)
    end
  end

  private

  def ui_last_commits
    commit_objects = Octokit.commits(Deployer.config.ui_repo) rescue []
    commits = commit_objects.first(3).map do |c|
      { author: c.commit.author.name, date: c.commit.author.date,
        message: c.commit.message, sha: c.sha.first(8) }
    end
  end
end
