
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
$('#home-section').on('show', function () { });
$('#nodes-section').on('show', function () { uiUpdateTable('nodes') });
$('#reports-section').on('show', function () { uiUpdateTable('reports') });
$('#configurations-section').on('show', function () { uiUpdateTable('configurations') });
$('#modules-section').on('show', function () { uiUpdateTable('modules') });

// Events for the content hide (navigate from)
$('#home-section').on('hide', function () { });
$('#nodes-section').on('hide', function () { uiClearTable('nodes') });
$('#reports-section').on('hide', function () { uiClearTable('reports') });
$('#configurations-section').on('hide', function () { uiClearTable('configurations') });
$('#modules-section').on('hide', function () { uiClearTable('modules') });



// USER INTERFACE
// ==============

$('#modal').on('hidden.bs.modal', function (e) {
    $('#modal-title').html('');
    $('#modal-text').html('');
})

function uiShowModal(title, text) {
    $('#modal-title').html(title);
    $('#modal-text').html(text);
    $('#modal').modal();
}

function uiShowModalHttpRequestError(xhr, message) {
    var verbose = "<br /><br />";
    try {
        var responseObject = JSON.parse(xhr.responseText);
        verbose += "Message: " + responseObject.Message + "<br />";
        verbose += "Exception: " + responseObject.ExceptionMessage + "<br />";
        verbose += "Type: " + responseObject.ExceptionType + "<br /><br />";
        verbose += "Stack Trace: " + responseObject.StackTrace + "<br />";
    }
    catch (error) {
        // No verbose message available
    }

    title = xhr.status + ' ' + xhr.statusText;
    text = message + '<br />' + verbose;

    uiShowModal(title, text);
}

function uiUpdateTable(page) {
    uiShowTableLoader(page);
    uiClearTable(page);
    $.getJSON('/api/' + page)
        .done(function (data) {
            $.each(data, function (key, item) {
                $('#table-' + page + '-content > div > table > tbody').append(uiCreateTableRow(page, item));
            });
        })
        .fail(function (xhr) {
            uiShowModalHttpRequestError(xhr, 'Unable to refresh the ' + page + '.');
        });
    uiShowTableContent(page);
}

function uiClearTable(page) {
    $('#table-' + page + '-content > div > table > tbody').empty()
}

function uiShowTableLoader(page) {
    $('#table-' + page + '-content').hide()
    $('#table-' + page + '-loader').show()
}

function uiShowTableContent(page) {
    $('#table-' + page + '-loader').hide()
    $('#table-' + page + '-content').show()
}

function uiCreateTableRow(page, item) {
    var html;
    switch (page) {
        case "nodes":
            html += uiCreateTableCell(item.AgentId);
            html += uiCreateTableCell(item.NodeName);
            html += uiCreateTableCell(item.LCMVersion);
            html += uiCreateTableCell(item.IPAddress.split(";").join("<br>"));
            html += uiCreateTableCell(item.ConfigurationNames);
            break;
        case "reports":
            html += uiCreateTableCell("ToDo");
            break;
        case "configurations":
            html += uiCreateTableCell(item.Name);
            html += uiCreateTableCell(uiFormatSize(item.Size));
            html += uiCreateTableCell(uiFormatDateTime(item.Created));
            html += uiCreateTableCell(uiFormatChecksum(item.Checksum));
            html += uiCreateTableCell(uiFormatChecksumStatus(item.ChecksumStatus))
            html += uiCreateTableCell(
                uiCreateTableButtonDownload(page, item.Name, item.Name + '.mof') + ' ' +
                uiCreateTableButtonHash('apiHashConfiguration(\'' + item.Name + '\')') + ' ' +
                uiCreateTableButtonRemove('apiDeleteConfiguration(\'' + item.Name + '\')')
            );
            break;
        case 'modules':
            html += uiCreateTableCell(item.Name);
            html += uiCreateTableCell(item.Version);
            html += uiCreateTableCell(uiFormatSize(item.Size));
            html += uiCreateTableCell(uiFormatDateTime(item.Created));
            html += uiCreateTableCell(uiFormatChecksum(item.Checksum));
            html += uiCreateTableCell(uiFormatChecksumStatus(item.ChecksumStatus))
            html += uiCreateTableCell(
                uiCreateTableButtonDownload(page, item.Name + '/' + item.Version, item.Name + '_' + item.Version + '.zip') + ' ' +
                uiCreateTableButtonHash('apiHashModule(\'' + item.Name + '\', \'' + item.Version + '\')') + ' ' +
                uiCreateTableButtonRemove('apiDeleteModule(\'' + item.Name + '\', \'' + item.Version + '\')')
            );
            break;
    }
    return '<tr>' + html + '</tr>';
}

function uiCreateTableCell(html) {
    return '<td>' + html + '</td>';
}

function uiCreateTableButtonDownload(page, relative, filename) {
    return '<a type="button" target="_blank" href="/api/' + page + '/' + relative + '/download/' + filename + '" class="btn btn-default btn-xs" title="Download"><span class="glyphicon glyphicon-download-alt"></span></a>';
}

function uiCreateTableButtonHash(callback) {
    return '<button type="button" class="btn btn-default btn-xs" title="Calculate Checksum" onclick="' + callback + '"><span class="glyphicon glyphicon-repeat"></span></button>';
}

function uiCreateTableButtonRemove(callback) {
    return '<button type="button" class="btn btn-danger btn-xs" title="Remove" onclick="' + callback + '"><span class="glyphicon glyphicon-remove"></span></button>';
}

function uiFormatDateTime(datetime) {
    return $.format.date(new Date(datetime), 'yyyy-MM-dd HH:mm:ss');
}

function uiFormatSize(size) {
    return Math.round(size / 1024) + ' KB'
}

function uiFormatChecksum(checksum) {
    return '<code class="page-tooltip">' + checksum.substring(0, 8).toLowerCase() + '<span class="page-tooltip-text">' + checksum.toLowerCase() + '</span></code>';
}

function uiFormatChecksumStatus(checksumStatus) {
    switch (checksumStatus) {
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
    return '<span class="label label-' + style + '">' + checksumStatus + '</span>';
}



// EVENT LISTENERS: NODES
// ===============================

$('#nodesRefreshButton').on("click", function (e) {
    uiUpdateTable('nodes');
});



// EVENT LISTENERS: REPORTS
// ===============================

$('#reportsRefreshButton').on("click", function (e) {
    uiUpdateTable('reports');
});



// EVENT LISTENERS: CONFIGURATIONS
// ===============================

$('#configurationsUploadButton').on('change', function (e) {
    if (e.target.files.length != 1) {
        uiShowModal('Configuration Upload Failed', 'Please select exactly one file to upload.')
        return;
    }
    if (this.value.lastIndexOf('.mof') === -1) {
        uiShowModal('Configuration Upload Failed', 'Please select a valid MOF-file with the extension .mof.')
        return;
    }
    if (window.FormData === undefined) {
        uiShowModal('Configuration Upload Failed', 'This browser doesn\'t support HTML5 file uploads.')
        return;
    }
    apiUploadConfiguration(e.target.files[0]);
    $('#configurationsUploadButton').val('')
});

$('#configurationsRefreshButton').on("click", function (e) {
    uiUpdateTable('configurations');
});



// EVENT LISTENERS: MODULES
// ========================

$('#modulesUploadButton').on('change', function (e) {
    if (e.target.files.length != 1) {
        uiShowModal('Module Upload Failed', 'Please select exactly one file to upload.')
        return;
    }
    if (this.value.lastIndexOf('.zip') === -1) {
        uiShowModal('Module Upload Failed', 'Please select a valid zip-file with the extension .zip.')
        return;
    }
    if (window.FormData === undefined) {
        uiShowModal('Module Upload Failed', 'This browser doesn\'t support HTML5 file uploads.')
        return;
    }
    apiUploadModule(e.target.files[0]);
    $('#modulesUploadButton').val('')
});

$('#modulesRefreshButton').on("click", function (e) {
    uiUpdateTable('modules');
});



// WEB API CALLS: CONFIGURATIONS
// =============================

function apiUploadConfiguration(file) {
    var name = file.name.substring(0, file.name.length - 4)
    $.ajax({
        type: "PUT",
        url: '/api/configurations/' + name,
        contentType: false,
        processData: false,
        data: file,
        success: function (result) {
            uiUpdateTable('configurations');
        },
        error: function (xhr) {
            uiShowModalHttpRequestError(xhr, 'Failed to upload the configuration ' + name + '.');
            uiUpdateTable('configurations');
        }
    });
}

function apiHashConfiguration(name) {
    $.ajax({
        url: '/api/configurations/' + name + '/hash',
        type: 'GET',
        success: function (result) {
            uiUpdateTable('configurations');
        },
        error: function (xhr) {
            uiShowModalHttpRequestError(xhr, 'Failed to hash the configuration ' + name + '.');
            uiUpdateTable('configurations');
        }
    });
}

function apiDeleteConfiguration(name) {
    $.ajax({
        url: '/api/configurations/' + name,
        type: 'DELETE',
        success: function (result) {
            uiUpdateTable('configurations');
        },
        error: function (xhr) {
            uiShowModalHttpRequestError(xhr, 'Failed to delete the configuration ' + name + '.');
            uiUpdateTable('configurations');
        }
    });
}



// WEB API CALLS: MODULES
// ======================

function apiUploadModule(file) {
    var parts   = file.name.substring(0, file.name.length - 4).split('_', 2)
    var name    = parts[0];
    var version = parts[1];
    $.ajax({
        type: "PUT",
        url: '/api/modules/' + name + '/' + version,
        contentType: false,
        processData: false,
        data: file,
        success: function (result) {
            uiUpdateTable('modules');
        },
        error: function (xhr) {
            uiShowModalHttpRequestError(xhr, 'Failed to upload the module ' + name + ' with version ' + version + '.');
            uiUpdateTable('modules');
        }
    });
}

function apiHashModule(name, version) {
    $.ajax({
        url: '/api/modules/' + name + '/' + version + '/hash',
        type: 'GET',
        success: function (result) {
            uiUpdateTable('modules');
        },
        error: function (xhr) {
            uiShowModalHttpRequestError(xhr, 'Failed to hash the module ' + name + ' with version ' + version + '.');
            uiUpdateTable('modules');
        }
    });
}

function apiDeleteModule(name, version) {
    $.ajax({
        url: '/api/modules/' + name + '/' + version,
        type: 'DELETE',
        success: function (result) {
            uiUpdateTable('modules');
        },
        error: function (xhr) {
            uiShowModalHttpRequestError(xhr, 'Failed to delete the module ' + name + ' with version ' + version + '.');
            uiUpdateTable('modules');
        }
    });
}


