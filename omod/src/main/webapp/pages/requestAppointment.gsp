<%
    def angularLocale = context.locale.toString().toLowerCase();

    ui.decorateWith("appui", "standardEmrPage")

    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("uicommons", "i18n/angular-locale_" + angularLocale + ".js")
    ui.includeJavascript("uicommons", "angular-ui/ui-bootstrap-tpls-0.6.0.min.js")
    ui.includeJavascript("uicommons", "angular-resource.min.js")
    ui.includeJavascript("uicommons", "moment.min.js")

    ui.includeJavascript("uicommons", "services/providerService.js")

    ui.includeJavascript("appointmentschedulingui","app.js")
    ui.includeJavascript("appointmentschedulingui", "services/appointmentService.js")
    ui.includeJavascript("appointmentschedulingui", "resources/appointmentResources.js")
    ui.includeJavascript("appointmentschedulingui", "controllers/requestAppointmentController.js")

    ui.includeCss("appointmentschedulingui", "requestAppointment.css")


    def returnUrl;

    if (returnProvider && returnPage) {
        returnUrl = ui.pageLink(returnProvider, returnPage, [patientId: patient.patient.id])
    }

%>

<%= ui.includeFragment("appui", "messages", [ codes: [
        'appointmentschedulingui.requestAppointment.errorRequestingAppointment',
        'appointmentschedulingui.timeframeunits.DAYS',
        'appointmentschedulingui.timeframeunits.WEEKS',
        'appointmentschedulingui.timeframeunits.MONTHS',
        'appointmentschedulingui.timeframeunits.YEARS'
].flatten()
]) %>

<!-- TODO better handle the breadcrumb format if this page is going to have multiple entry points? -->

<script type="text/javascript" xmlns="http://www.w3.org/1999/html">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.patient.familyName) }, ${ ui.format(patient.patient.givenName) }", link: "${ returnUrl ? ui.escapeJs(returnUrl) : ''}" },
        { label: "${ ui.message("appointmentschedulingui.requestAppointment.label")}" }
    ];

</script>

${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient.patient ]) }

<%= ui.includeFragment("appointmentschedulingui", "timeZoneWarning") %>

<div class="scheduleAppointment" ng-app="appointmentscheduling.requestAppointment" ng-controller="RequestAppointmentCtrl"  ng-init="init('${ patient.patient.uuid }', '${ currentProvider?.uuid }', '${ returnProvider }', '${ returnPage }')">

    <h2>
        ${ ui.message("appointmentschedulingui.requestAppointment.label") }
    </h2>

    <form class="create-appointment-request">

        <p>
            <label> ${ ui.message("appointmentschedulingui.requestAppointment.selectAppointmentType") }</label>
            <input id="appointment-type" type="text" ng-model="appointmentRequest.appointmentType" typeahead-editable="false" typeahead="appointmentType as appointmentType.display for appointmentType in getAppointmentTypes(\$viewValue) | filter: \$viewValue | limitTo:8" >
        </p>

        <p>
            <label> ${ ui.message("appointmentschedulingui.requestAppointment.selectProvider") }</label>
            <input id="provider" type="text" ng-model="appointmentRequest.provider" typeahead-editable="false" typeahead="provider as provider.person.display for provider in getProviders(\$viewValue) | filter: \$viewValue | limitTo:8" />
        </p>

        <p>
            <label> ${ ui.message("appointmentschedulingui.requestAppointment.selectTimeFrame") }</label>
            <input id="min-time-frame-value" type="text" ng-model="appointmentRequest.minTimeFrameValue" ng-change="verifyTimeFrameValues()" size="2" maxlength="2" />
            <select id="min-time-frame-units" ng-model="appointmentRequest.minTimeFrameUnits"  ng-options="t.value as t.display for t in timeFrameUnits">
            </select>
            ${ ui.message("appointmentschedulingui.requestAppointment.to") }
            <input id="max-time-frame-value" type="text" ng-model="appointmentRequest.maxTimeFrameValue" size="2" maxlength="2" />
            <select id="max-time-frame-units" ng-model="appointmentRequest.maxTimeFrameUnits" ng-options="t.value as t.display for t in timeFrameUnits">
            </select>
        </p>

        <p>
            <label>${ ui.message("appointmentschedulingui.requestAppointment.notes") } </label>
            <textarea id="notes" ng-model="appointmentRequest.notes"></textarea>
        </p>

        <div>
            <input type="button" class="cancel" value="${ ui.message("appointmentschedulingui.appointmenttype.cancel") }" ng-click="cancel()" />
            <input type="button" class="confirm" ng-disabled="!validateAppointmentRequest()" id="save-button" ng-click="saveAppointmentRequest()" value="${ ui.message("appointmentschedulingui.appointmenttype.save") }"  />
        </div>
    </form>


</div>