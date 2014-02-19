$ ->

  $(".redirect").click  (event) ->
    window.location.href = $(@).data('action')

  $('#deploy_ui').click (event) ->
    event.preventDefault()

    $('.keyboard').hide()
    $('.last_commits').hide()
    $('p').hide()

    spinner = createSpinner({ color: '#fff' })
    performDeploy spinner

  $('#deploy_api').click (event) ->
    event.preventDefault()

    $(@).hide()
    spinner = createSpinner()
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

        intervalId = setInterval (->
          response = checkDeploy(deploy_uid)
          if response.responseJSON.state == 'deployed'
            destroySpinner spinner
            $('.title').html 'Deployed successfully!'
            clearInterval intervalId
        ), 2000

  checkDeploy = (deploy_uid) ->
    $.ajax
      url: "deploy/check_deploy/#{deploy_uid}"
      type: "GET"
      async: false

  window.checkDeploy = checkDeploy

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
