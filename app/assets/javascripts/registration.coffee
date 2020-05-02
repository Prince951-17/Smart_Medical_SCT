$ ->
  my.initAjax()

  Glob = window.Glob || {}

  apiUrl =
    send: '/registration'
    getOrganization: '/getOrganizationName'
    getDepartment: '/get-department-for-organization'
    searchByName: '/search-patient-by-name'

  defaultSearchData =
    fullName: ''
    passportSn: ''

  vm = ko.mapping.fromJS
    search: defaultSearchData
    selectedOrganization: []
    organizationList: []
    selectedDepartment: []
    workTypeList: []
    patientList: []
    language: Glob.language

  handleError = (error) ->
    if error.status is 500 or (error.status is 400 and error.responseText)
      toastr.error(error.responseText)
    else
      toastr.error('Something went wrong! Please try again.')

  getOrganization = ->
    $.get(apiUrl.getOrganization)
    .fail handleError
    .done (response) ->
      vm.organizationList(response)
  getOrganization()

  vm.selectedOrganization.subscribe (name) ->
    if (name isnt undefined )
      $.post(apiUrl.getDepartment, JSON.stringify({name: name}))
       .fail handleError
       .done (response) ->
         vm.workTypeList(response)

  $('#search-by-name').keyup (event) ->
    if (event.keyCode == 13)
      count = vm.search.fullName().split(" ").length
      name = vm.search.fullName().split(" ")
      data =
        if count is 1
          lastName: name[0]
        else if count is 2
          lastName: name[0]
          firstName: name[1]
        else if count is 3
          lastName: name[0]
          firstName: name[1]
          secondName: name[2]
        else if count is 4
          lastName: name[0]
          firstName: name[1]
          secondName: name[2] + " " + name[3]
        else
          toastr.error("Iltimos ko'rsatilgan tartibda kiriting: \n Bemor Familiyasi Ismi Sharifi")
      $.post(apiUrl.searchByName, JSON.stringify(data))
      .fail handleError
      .done (response) ->
        for obj in response
          obj.fullName = obj.lastName + " " + obj.firstName + " " + obj.middleName
        vm.patientList(response)
        $('#demo1').selectMultiple();




  vm.translate = (fieldName) -> ko.computed () ->
    index = if vm.language() is 'en' then 0 else 1
    vm.labels[fieldName][index]

  vm.labels =
    label: [
      "Hello World!"
      "Salom Dunyo!"
    ]

  ko.applyBindings {vm}