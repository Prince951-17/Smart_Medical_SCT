$ ->
  my.initAjax()

  Glob = window.Glob || {}

  apiUrl =
    send: '/addCheckupPeriod'
    getWorkType: '/get-workType'
    updateCheckupPeriod: '/update-checkupPeriod'
    deleteWorkType: '/deleteWorkType'
    getLab: '/getLaboratory'
    getDoctor: '/getDoctorType'

  defaultForm =
    numberPerYear: ''
    selectedDoctorType: []
    selectedLabType: []

  vm = ko.mapping.fromJS
    labTypeList: []
    workType: ''
    workTypeList: []
    getCheckupPeriodList: []
    getWorkTypeList: []
    language: Glob.language
    formA: []
    selectedId: ''

  handleError = (error) ->
    if error.status is 500 or (error.status is 400 and error.responseText) or error.status is 200
      toastr.error(error.responseText)
    else
      toastr.error('Something went wrong! Please try again.')

  vm.formA.push ko.mapping.fromJS(defaultForm)
  getLabTypeList = ->
    $.get(apiUrl.getLab)
    .fail handleError
    .done (response) ->
      vm.labTypeList response
  getLabTypeList()

  getDoctorTypeList = ->
    $.get(apiUrl.getDoctor)
    .fail handleError
    .done (response) ->
      vm.getCheckupPeriodList response
  getDoctorTypeList()

  vm.addForm = -> ->
    if(ko.mapping.toJS(vm.formA()).length < 4)
      vm.formA.push ko.mapping.fromJS(defaultForm)
    else
      alert("Yetarlicha maydon qo'shildi.")

  vm.deleteForm = ->
    if(ko.mapping.toJS(vm.formA()).length > 1)
      vm.formA(vm.formA().slice(0, -1))

  vm.addCheckupPeriod = ->
    toastr.clear()
    if (!vm.workType())
      toastr.error("please enter the work type!")
      return no
    else if ko.mapping.toJS(vm.formA()).length is 0
      toastr.error("please click button plus")
      return no
    else
      for form in ko.mapping.toJS(vm.formA())
        if (!form.numberPerYear)
          toastr.error("please enter the number per year!")
          return no
        else if (form.selectedDoctorType.length is 0)
          toastr.error("please enter the doctor type!")
          return no
        else if (form.selectedLabType.length is 0)
          toastr.error("please enter the laboratory type!")
          return no
      data =
        workType: vm.workType()
        form: ko.mapping.toJS(vm.formA())
      $.ajax
        url: apiUrl.send
        type: 'POST'
        data: JSON.stringify(data)
        dataType: 'json'
        contentType: 'application/json'
      .fail handleError
      .done (response) ->
        toastr.success(response)
        $('#addCheckupPeriod').modal('hide')
        getCheckupPeriod()

  getCheckupPeriod = ->
    $.ajax
      url: apiUrl.getWorkType
      type: 'GET'
    .fail handleError
    .done (response) ->
      for k,v of response
        vm.workTypeList.push(k)
      vm.getWorkTypeList(response)

  getCheckupPeriod()

  vm.returnDoctorType = (specPart) ->
    specPart.specPartJson.docType

  vm.returnLabType = (specPart) ->
    specPart.specPartJson.labType

  vm.checkupLength = (list) ->
    list.length

  vm.askDelete = (data) -> ->
    vm.selectedId data[0].id
    $('#delete').modal('show')

  vm.openEditForm = (data) -> ->
    vm.selectedId data[0].id
    vm.workType data[0].workType
    console.log data[1]
    defaultForm.numberPerYear
    vm.formA(data[1])
    $('#edit_work_type').modal('show')

  vm.deleteWorkTypeAndCheckup = ->
    data =
      id: vm.selectedId()
    $.ajax
      url: apiUrl.deleteWorkType
      type: 'DELETE'
      data: JSON.stringify(data)
      dataType: 'json'
      contentType: 'application/json'
    .fail handleError
    .done (response) ->
      $('#delete').modal('hide')
      toastr.success(response)
      $(this).parents('tr').remove()
      getCheckupPeriod()

  vm.translate = (fieldName) -> ko.computed () ->
    index = if vm.language() is 'en' then 0 else 1
    vm.labels[fieldName][index]

  vm.labels =
    label: [
      "Hello World!"
      "Salom Dunyo!"
    ]

  ko.applyBindings {vm}