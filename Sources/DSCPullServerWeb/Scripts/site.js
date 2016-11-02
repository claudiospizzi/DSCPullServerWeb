
// DEFINITION
// ==========

// Function to enable event for show and hide of the section
(function ($) {
    $.each(['show', 'hide'], function (i, ev) {
        var el = $.fn[ev];
        $.fn[ev] = function () {
            this.trigger(ev);
            return el.apply(this, arguments);
        };
    });
})(jQuery);

// Global constants
var pages = ['home', 'nodes', 'reports', 'configurations', 'modules']



// NAVIGATION
// ==========

// Click events for the navigation
pages.forEach(function (value, index, array) {
    $('#' + value + '-nav').click(function () { navigate(value) })
})

// Navigation function
function navigate(section) {

    // Hide all pages and remove navigation active highlighting
    pages.forEach(function (value, index, array) {
        $('#' + value + '-section').hide()
        $('#' + value + '-nav').parent().removeClass("active");
    })

    // Show the target page and mark the navigation as active
    $('#' + section + '-section').show()
    $('#' + section + '-nav').parent().addClass("active");

    // Hide the toggle navbar is needed
    if ($('.navbar-toggle').css('display') != 'none') {
        $('.navbar-toggle').click()
    }
}

// Events for the content show (navigate to)
$('#home-section').on('show', function () { updateHome() });
$('#nodes-section').on('show', function () { updateNodes() });
$('#reports-section').on('show', function () { updateReports() });
$('#configurations-section').on('show', function () { updateConfigurations() });
$('#modules-section').on('show', function () { updateModules() });

// Events for the content hide (navigate from)
$('#home-section').on('hide', function () { clearHome() });
$('#nodes-section').on('hide', function () { clearNodes() });
$('#reports-section').on('hide', function () { clearReports() });
$('#configurations-section').on('hide', function () { clearConfigurations() });
$('#modules-section').on('hide', function () { clearModules() });



// HOME PAGE
// =========

function updateHome() {

}

function clearHome() {

}



// NODES PAGE
// ==========

function updateNodes() {
}

function clearNodes() {
}



// REPORTS PAGE
// ============

function updateReports() {
}
function clearReports() {
}



// CONFIGURATIONS PAGE
// ===================



// MODULES PAGE
// ============

function updateModules() {
    //clearModules();
    //$.getJSON('/api/modules')
    //    .done(function (data) {
    //        // On success, 'data' contains a list of modules.
    //        $.each(data, function (key, item) {
    //            $('#modules-table').append(formatModuleTableRow(item))
    //        });
    //    });
}

function clearModules() {
    //$('#modules-table').empty()
}

function formatModuleTableRow(item) {
    //return '<tr><td>' + item.Name + '</td><td>' + item.Version + '</td></tr>';
}


//************************************************************************************
// NEW

function update() {

    var path = window.location.pathname.toString()

    var pages = ['Nodes', 'Reports', 'Configurations', 'Modules', 'Cmdlets', 'RestApi']
    
    pages.forEach(function (value, index, array) {

        if (path.indexOf("/Web/" + value) == 0) {

            $('.' + value.toLowerCase() + '-nav').parent().addClass("active");
        }
    })

    if (path.indexOf("/Web/Configurations") == 0) {

        updateConfigurations();
    }
}

function updateConfigurations() {
    clearConfigurations();
    $.getJSON('/api/configurations')
        .done(function (data) {
            $.each(data, function (key, item) {
                $('#configurations-table > div > table > tbody').append(formatConfigurationTableRow(item));
            });
        })
        .fail(function (jqxhr, textStatus, error) {
            $('#configurations-table').append(formatConfigurationTableRowException(jqxhr.status + ' / ' + jqxhr.responseText + ' / ' + textStatus + ' / ' + error));
        });
}

function clearConfigurations() {
    $('#configurations-table > div > table > tbody').empty()
}

function formatConfigurationTableRow(item) {
    return '<tr><td>' + item.Name + '</td><td>' + item.Checksum + '</td><td><span class="label label-danger">' + item.ChecksumStatus + '</span></td><td><button type="button" class="btn btn-default btn-xs">Delete</button></td></tr>';
}

function formatConfigurationTableRowException(message) {
    return '<tr class="danger"><td rowspan="1" style="text-align: center;">' + message + '<td></tr>'
}
