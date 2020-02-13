$ ->
  my.initAjax()

  Glob = window.Glob || {}

  apiUrl =
    send: '/addOrganization'
    get: '/getOrganization'
    delete: '/deleteOrganization'
    update: '/updateOrganization'

  vm = ko.mapping.fromJS
    organizationName: ''
    user: defaultUserdata
    getList: []
    roleList: []
    id: 0
    after: ''


  defaultUserdata =
    selectedRoles: []

  handleError = (error) ->
    if error.status is 500 or (error.status is 400 and error.responseText)
      toastr.error(error.responseText)
    else
      toastr.error('Something went wrong! Please try again.')

  vm.onSubmit = ->
    toastr.clear()
    if (!vm.organizationName())
      toastr.error("Please enter a Organization Name")
      return no
    else
      data =
        organizationName: vm.organizationName()
      $.ajax
        url: apiUrl.send
        type: 'POST'
        data: JSON.stringify(data)
        dataType: 'json'
        contentType: 'application/json'
      .fail handleError
      .done (response) ->
        toastr.success(response)

  vm.getOrganization = ->
    $.ajax
      url: apiUrl.get
      type: 'GET'
    .fail handleError
    .done (response) ->
      vm.getList(response)

  vm.getOrganization()


  $(document).on 'click', '.deleteOrganization', ->
    row = $(this).closest('tr').children('td')
    data =
      id: row[0].innerText
    $.ajax
      url: apiUrl.delete
      type: 'DELETE'
      data: JSON.stringify(data)
      dataType: 'json'
      contentType: 'application/json'
    .fail handleError
    .done (response) ->
      toastr.success(response)
    $(this).parents('tr').remove()

  vm.updateOrganization = ->
    data =
      id: parseInt(vm.id())
      organizationName: vm.organizationName()
    $.ajax
      url: apiUrl.update
      type: 'POST'
      data: JSON.stringify(data)
      dataType: 'json'
      contentType: 'application/json'
    .fail handleError
    .done (response) ->
      toastr.success(response)

  $(document).on 'click', '.clickOnRow', ->
    row = $(this).closest('tr')
    if row.next('tr').hasClass('hide')
      row.next('tr').show(1000).removeClass('hide').addClass('show')
    else
      row.next('tr').hide(1000).removeClass('show').addClass('hide')




  ko.applyBindings {vm}
