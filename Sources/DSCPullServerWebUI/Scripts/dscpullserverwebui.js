
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
var uri = 'http://localhost:35217/api'



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

function updateConfigurations() {
    clearConfigurations();
    $.getJSON(uri + '/configurations')
        .done(function (data) {
            // On success, 'data' contains a list of configurations.
            $.each(data, function (key, item) {
                $('#configurations-table').append(formatConfigurationTableRow(item))
            });
        });
}

function clearConfigurations() {
    $('#configurations-table').empty()
}

function formatConfigurationTableRow(item) {
    return '<tr><td>' + item.Name + '</td></tr>';
}



// MODULES PAGE
// ============

function updateModules() {
    clearModules();
    $.getJSON(uri + '/modules')
        .done(function (data) {
            // On success, 'data' contains a list of modules.
            $.each(data, function (key, item) {
                $('#modules-table').append(formatModuleTableRow(item))
            });
        });
}

function clearModules() {
    $('#modules-table').empty()
}

function formatModuleTableRow(item) {
    return '<tr><td>' + item.Name + '</td><td>' + item.Version + '</td></tr>';
}
