
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


function clearModules() {
    //$('#modules-table').empty()
}

function formatModuleTableRow(item) {
    //return '<tr><td>' + item.Name + '</td><td>' + item.Version + '</td></tr>';
}


//************************************************************************************
// NEW


$('#configurationsUploadButton').on('change', function (e) {
    var files = e.target.files;
    if (files.length > 0) {
        if (this.value.lastIndexOf('.mof') === -1) {
            alert('Only mof files are allowed!');
            this.value = '';
            return;
        }
        if (window.FormData !== undefined) {
            var data = new FormData();
            for (var x = 0; x < files.length; x++) {
                data.append("file" + x, files[x]);
            }

            $.ajax({
                type: "PUT",
                url: '/api/Configurations/MyConfTest',
                contentType: false,
                processData: false,
                data: data,
                success: function (result) {
                    console.log(result);
                },
                error: function (xhr, status, p3, p4) {
                    var err = "Error " + " " + status + " " + p3 + " " + p4;
                    if (xhr.responseText && xhr.responseText[0] == "{")
                        err = JSON.parse(xhr.responseText).Message;
                    console.log(err);
                }
            });
        } else {
            alert("This browser doesn't support HTML5 file uploads!");
        }
    }
});

$('#configurationsRefreshButton').on("click", function (e) {
    updateConfigurations();
});

$('#modulesRefreshButton').on("click", function (e) {
    updateModules();
});

function update() {
    var path = window.location.pathname.toString()
    if (path.indexOf("/Web/Configurations") == 0) { updateConfigurations(); }
    if (path.indexOf("/Web/Modules") == 0) { updateModules(); }
}

function clearTableContent(page) {
    $('#table-' + page + '-content > div > table > tbody').empty()
}

function showTableContent(page) {
    $('#table-' + page + '-content').show()
    $('#table-' + page + '-loader').hide()
    $('#table-' + page + '-exception').hide()
}

function showTableLoader(page) {
    $('#table-' + page + '-content').hide()
    $('#table-' + page + '-loader').show()
    $('#table-' + page + '-exception').hide()
}

function showTableException(page) {
    $('#table-' + page + '-content').hide()
    $('#table-' + page + '-loader').hide()
    $('#table-' + page + '-exception').show()
}

function updateConfigurations() {
    showTableLoader('configurations');
    clearTableContent('configurations');
    $.getJSON('/api/configurations')
        .done(function (data) {
            $.each(data, function (key, item) {
                $('#table-configurations-content > div > table > tbody').append(formatConfigurationTableRow(item));
            });
            showTableContent('configurations');
        })
        .fail(function (jqxhr, textStatus, error) {
            $('#table-configurations-exception > p').empty();
            $('#table-configurations-exception > p').append(formatConfigurationTableRowException(jqxhr.status + '. ' + error));
            showTableException('configurations');
        });
}

function updateModules() {
    showTableLoader('modules');
    clearTableContent('modules');
    $.getJSON('/api/modules')
        .done(function (data) {
            $.each(data, function (key, item) {
                $('#table-modules-content > div > table > tbody').append(formatModulesTableRow(item));
            });
            showTableContent('modules');
        })
        .fail(function (jqxhr, textStatus, error) {
            $('#table-modules-exception > p').empty();
            $('#table-modules-exception > p').append(formatConfigurationTableRowException(jqxhr.status + '. ' + error));
            showTableException('modules');
        });
}

function formatModulesTableRow(item) {
    buttonDownload = createTableLink('Download', 'default', 'download-alt', '/api/modules/' + item.Name + '/' + item.Version + '/download/' + item.Name + '_' + item.Version + '.zip');



    name = convertStringToCell(item.Name)
    version  = convertStringToCell(item.Version)
    date     = convertStringToCell(convertDateTimeToString(item.Created));
    checksum = convertStringToCell(convertChecksumToCode(item.Checksum));
    status = convertStringToCell(convertStatusToLabel(item.ChecksumStatus));
    button = convertStringToCell(buttonDownload);


    return '<tr>' + name + version + date + checksum + status + button + '</tr>';
    //return '<tr>' + name + version + date + checksum + status + '<td><button type="button" class="btn btn-default btn-xs">Delete</button></td></tr>';
}

function formatConfigurationTableRow(item) {
    name     = convertStringToCell(item.Name)
    date     = convertStringToCell(convertDateTimeToString(item.Created));
    checksum = convertStringToCell(convertChecksumToCode(item.Checksum));
    status   = convertStringToCell(convertStatusToLabel(item.ChecksumStatus));
    button   = convertStringToCell(createTableLink('Download', 'default', 'download-alt', '/api/configurations/' + item.Name + '/download.zip') + ' ' + convertLinkToRepeatButton('') + ' ' + convertLinkToRemoveButton(''));

    return '<tr>' + name + date + checksum + status + button + '</tr>';
    //return '<tr><td>' + item.Name + '</td><td>' + $.format.date(new Date(item.Created), 'yyyy-MM-dd HH:mm:ss') + '</td><td><code>' + item.Checksum.substring(0, 10).toLowerCase() + '</code></td><td><span class="label label-danger" data-toggle="tooltip" title="foo">' + item.ChecksumStatus + '</span></td><td><button type="button" class="btn btn-default btn-xs">Delete</button></td></tr>';
}

function formatConfigurationTableRowException(message) {
    //return '<tr class="danger"><td rowspan="1" style="text-align: center;">' + message + '<td></tr>'
    return message;
}

function convertStringToCell(string) {
    return '<td>' + string + '</td>'
}

function convertDateTimeToString(date) {
    return $.format.date(new Date(date), 'yyyy-MM-dd HH:mm:ss');
}

function convertChecksumToCode(checksum) {
    return '<code>' + checksum.substring(0, 12).toLowerCase() + '</code>';
}

function convertStatusToLabel(status) {
    switch(status) {
        case 'Valid':
            style = 'success';
            break;
        case 'Invalid':
            style = 'danger';
            break;
        case 'Missing':
            style = 'warning';
            break;
        default:
            style = 'default';
    }
    return '<span class="label label-' + style + '">' + status + '</span>';
}

function convertLinkToDownloadButton(link) {

    return '<button type="button" class="btn btn-default btn-xs" title="Download"><span class="glyphicon glyphicon-download-alt"></span></button>';
}

function convertLinkToRepeatButton(link) {

    return '<button type="button" class="btn btn-default btn-xs" title="Calculate Checksum"><span class="glyphicon glyphicon-repeat"></span></button>';
}

function convertLinkToRemoveButton(link) {

    return '<button type="button" class="btn btn-danger btn-xs" title="Remove"><span class="glyphicon glyphicon-remove"></span></button>';
}

function createTableButton(title, type, icon, action) {
    return '<button type="button" onclick="' + action + '(this)" class="btn btn-' + type + ' btn-xs" title="' + title + '"><span class="glyphicon glyphicon-' + icon + '"></span></button>';
}

function createTableLink(title, type, icon, href) {
    return '<a type="button" target="_blank" href="' + href + '" class="btn btn-' + type + ' btn-xs" title="' + title + '"><span class="glyphicon glyphicon-' + icon + '"></span></a>';
}

function DoDownload(source) {
    result = confirm('Test');
    alert(tmp);

}

