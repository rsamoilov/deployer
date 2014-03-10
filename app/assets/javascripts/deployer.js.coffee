$ ->

  $(".redirect").click  (event) ->
    window.location.href = $(@).data('action')

  $('#deploy_ui').click (event) ->
    event.preventDefault()

    $('.keyboard').hide()
    $('.last_commits').hide()
    $('p').hide()
    showDeployLogs()

    spinner = null#createSpinner({ color: '#fff' })
    performDeploy spinner

  $('#deploy_api').click (event) ->
    event.preventDefault()

    $(@).hide()
    showDeployLogs()
    spinner = null#createSpinner()
    performDeploy spinner

  createSpinner = (additional_options = {}) ->
    $('#loader').show()
    target = document.getElementById('loader')
    options = $.extend({}, spinnerOptions(), additional_options); 
    
    new Spinner(options).spin(target)

  destroySpinner = (spinner) ->
    spinner.stop()
    $('#loader').hide()

  performDeploy = (spinner) ->
    $('.title').html 'deploying...'

    $.ajax
      url: $('.deploy_button').data('action')
      type: "POST"
      success: (data) ->
        alert('Deploy is already running! Be patient...') if data.status == 'already_running'
        deploy_uid = data.deploy_uid

        dispatcher = new WebSocketRails("#{location.host}/websocket")
        logs_window = $('#deploy_logs')
        dispatcher.bind 'current_logs', (logs) ->
          parseLogs logs_window, logs
  
        channel = dispatcher.subscribe("deploy_log.#{deploy_uid}")
        channel.bind 'logs_update', (logs) ->
          parseLogs logs_window, logs

        dispatcher.trigger 'deploy_log.new_client', { deploy_uid: deploy_uid }

        channel.bind 'deploy_finish', ->
          # destroySpinner spinner
          $('.title').html 'Deployed successfully!'

  parseLogs = (logs_window, logs) ->
    $.each logs, (i, value) ->
      logs_window.append "#{value}<br>"
      logs_window.scrollTop logs_window[0].scrollHeight


  spinnerOptions = ->
    lines: 13
    length: 20
    width: 10
    radius: 30
    corners: 1
    rotate: 0
    direction: 1
    color: '#000'
    speed: 1
    trail: 60
    shadow: false
    hwaccel: false
    className: 'spinner'
    zIndex: 2e9
    top: 'auto'
    left: 'auto'
  window.spinnerOptions = spinnerOptions

  showDeployLogs = ->
    deploy_logs_el = $('#deploy_logs')
    deploy_logs_el.show()
    deploy_logs_el.animate
      width: '60%'
      height: '300px'
    , 1500
