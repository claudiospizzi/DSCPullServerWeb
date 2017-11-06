# Changelog

All notable changes to this project will be documented in this file.

The format is mainly based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).


## 1.1.0 - 2017-01-19

* Added: Windows Firewall rule for the DSC Pull Server Web port
* Added: Implement IIS Windows Authentication configuration
* Added: Confirm dialog before deleting configurations and modules
* Changed: Change target .NET Framework from v4.5.2 to v4.5


## 1.0.2 - 2017-01-05

* Changed: Update the DSC resource removal action


## 1.0.1 - 2017-01-05

* Fixed: Empty path in DSC resource
* Changed: GET /hash to PATCH /checksum


## 1.0.0 - 2017-01-05

* Added: Initial release
* Added: HTML5-based website with a user-friendly UI
* Added: REST API to interact with the DSC Pull Server
* Added: Cmdlets to interact with the REST API
* Added: DSC resource to setup the DSC Pull Server Web endpoint
