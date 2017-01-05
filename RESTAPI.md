
# DSCPullServerWeb REST API



## Overview

Action                                                                | Method   | URI
---                                                                   | ---      | ---
[Get All Configurations](#get-all-configurations)                     | `GET`    | /api/v1/configurations
[Get Configuration](#get-configuration)                               | `GET`    | /api/v1/configurations/{name}
[Calculate Configuration Checksum](#calculate-configuration-checksum) | `PATCH`  | /api/v1/configurations/{name}/checksum
[Download Configuration](#download-configuration)                     | `GET`    | /api/v1/configurations/{name}/download/{file}
[Upload Configuration](#upload-configuration)                         | `PUT`    | /api/v1/configurations/{name}
[Delete Configuration](#delete-configuration)                         | `DELETE` | /api/v1/configurations/{name}
[Get All Modules](#get-all-modules)                                   | `GET`    | /api/v1/modules
[Get All Module Versions](#get-all-module-versions)                   | `GET`    | /api/v1/modules/{name}
[Get Module](#get-module)                                             | `GET`    | /api/v1/modules/{name}/{version}
[Calculate Module Checksum](#calculate-module-checksum)               | `PATCH`  | /api/v1/modules/{name}/{version}/checksum
[Download Module](#download-module)                                   | `GET`    | /api/v1/modules/{name}/{version}/download/{file}
[Upload Module](#upload-module)                                       | `PUT`    | /api/v1/modules/{name}/{version}
[Delete Module](#delete-module)                                       | `DELETE` | /api/v1/modules/{name}/{version}



## Configurations


### Get All Configurations

Returns json data about all configurations.

* **URL**  
  /api/v1/configurations

* **Method**  
  `GET`

* **Query Parameters**  
  None

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  [
    {
        "Name": "FeatureDemo",
        "Size": 1846,
        "Created": "2016-11-17T20:32:44.8854668+01:00",
        "Checksum": "1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B",
        "ChecksumStatus": "Valid"
    },
    {
        "Name": "FileDemo",
        "Size": 2178,
        "Created": "2016-11-17T20:32:44.9054567+01:00",
        "Checksum": "2DEF328446FF7D9CA96DF51495394D26697CB43ADF3E671C133820755D2A6E2D",
        "ChecksumStatus": "Invalid"
    },
    {
        "Name": "RegistryDemo",
        "Size": 2026,
        "Created": "2016-11-17T20:32:44.9279475+01:00",
        "Checksum": "",
        "ChecksumStatus": "Missing"
    }
  ]
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/configurations" -UseDefaultCredentials
  ```


### Get Configuration

Returns json data about a single configuration.

* **URL**  
  /api/v1/configurations/{name}

* **Method**  
  `GET`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  {
    "Name": "FeatureDemo",
    "Size": 1846,
    "Created": "2016-11-17T20:32:44.8854668+01:00",
    "Checksum": "1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B",
    "ChecksumStatus": "Valid"
  }
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Configuration doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/configurations/FeatureDemo" -UseDefaultCredentials
  ```


### Calculate Configuration Checksum

Updates the checksum of a single configuration.

* **URL**  
  /api/v1/configurations/{name}/checksum

* **Method**  
  `GET`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  {
    "Name": "FeatureDemo",
    "Size": 1846,
    "Created": "2016-11-17T20:32:44.8854668+01:00",
    "Checksum": "1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B",
    "ChecksumStatus": "Valid"
  }
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Configuration doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Patch -Uri "$api/configurations/FeatureDemo/checksum" -UseDefaultCredentials
  ```


### Download Configuration

Download the configuration as MOF file. The file name is optional but usefull
when working with a web browser.

* **URL**  
  /api/v1/configurations/{name}/download/{file}

* **Method**  
  `GET`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*
  **file** `[string]` *OPTIONAL*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```mof
  /*
  @TargetNode='localhost'
  @GeneratedBy=claudio
  @GenerationDate=11/03/2016 11:06:58
  @GenerationHost=PC01
  */

  instance of MSFT_RoleResource as $MSFT_RoleResource1ref
  {
    ResourceID = "[WindowsFeature]RoleExample";
    Ensure = "Present";
    SourceInfo = "::35::9::WindowsFeature";
    Name = "Web-Server";
    ModuleName = "PsDesiredStateConfiguration";
    ModuleVersion = "1.0";
    ConfigurationName = "FeatureDemo";
  };
  instance of OMI_ConfigurationDocument
  {
    Version="2.0.0";
    MinimumCompatibleVersion = "1.0.0";
    CompatibleVersionAdditionalProperties= {"Omi_BaseResource:ConfigurationName"};
    Author="claudio";
    GenerationDate="11/03/2016 11:06:58";
    GenerationHost="PC01";
    Name="FeatureDemo";
  };
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Configuration doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/configurations/FeatureDemo/download" -OutFile 'C:\FeatureDemo.mof' -UseDefaultCredentials
  ```


### Upload Configuration

Update a new configuration.

* **URL**  
  /api/v1/configurations/{name}

* **Method**  
  `PUT`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*

* **Data Parameters**  
  ```mof
  /*
  @TargetNode='localhost'
  @GeneratedBy=claudio
  @GenerationDate=11/03/2016 11:06:58
  @GenerationHost=PC01
  */

  instance of MSFT_RoleResource as $MSFT_RoleResource1ref
  {
    ResourceID = "[WindowsFeature]RoleExample";
    Ensure = "Present";
    SourceInfo = "::35::9::WindowsFeature";
    Name = "Web-Server";
    ModuleName = "PsDesiredStateConfiguration";
    ModuleVersion = "1.0";
    ConfigurationName = "FeatureDemo";
  };
  instance of OMI_ConfigurationDocument
  {
    Version="2.0.0";
    MinimumCompatibleVersion = "1.0.0";
    CompatibleVersionAdditionalProperties= {"Omi_BaseResource:ConfigurationName"};
    Author="claudio";
    GenerationDate="11/03/2016 11:06:58";
    GenerationHost="PC01";
    Name="FeatureDemo";
  };
  ```

* **Success Response (200 OK):**  
  ```json
  {
    "Name": "FeatureDemo",
    "Size": 1846,
    "Created": "2016-11-17T20:32:44.8854668+01:00",
    "Checksum": "1AB2C0140C2B523156BE8142CD458FA20C5C2826879C7C37D97049E7DC25D66B",
    "ChecksumStatus": "Valid"
  }
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Put -Uri "$api/configurations/FeatureDemo" -InFile 'C:\FeatureDemo.mof' -UseDefaultCredentials
  ```


### Delete Configuration

Delete an existing configuration.

* **URL**  
  /api/v1/configurations/{name}

* **Method**  
  `DELETE`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  Empty

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Configuration doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method DELETE -Uri "$api/configurations/FeatureDemo" -UseDefaultCredentials
  ```



## Modules


### Get All Modules

Returns json data about all modules.

* **URL**  
  /api/v1/modules

* **Method**  
  `GET`

* **Query Parameters**  
  None

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  [
    {
      "Name": "SharePointDsc",
      "Version": "1.3.0.0",
      "Size": 429285,
      "Created": "2016-11-17T20:32:44.9479381+01:00",
      "Checksum": "EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47",
      "ChecksumStatus": "Valid"
    },
    {
      "Name": "SharePointDsc",
      "Version": "1.4.0.0",
      "Size": 441882,
      "Created": "2016-11-17T20:32:44.9634321+01:00",
      "Checksum": "35B1622E1890BAA2D529EDFB07285BEEFCFE8F8D3A4640FF785E1E30E64181A9",
      "ChecksumStatus": "Invalid"
    },
    {
      "Name": "SystemLocaleDsc",
      "Version": "1.1.0.0",
      "Size": 9566,
      "Created": "2016-11-17T20:32:44.9854245+01:00",
      "Checksum": "",
      "ChecksumStatus": "Missing"
    }
  ]
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/modules" -UseDefaultCredentials
  ```


### Get All Module Versions

Returns json data about all versions of a module.

* **URL**  
  /api/v1/modules/{name}

* **Method**  
  `GET`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  [
    {
      "Name": "SharePointDsc",
      "Version": "1.3.0.0",
      "Size": 429285,
      "Created": "2016-11-17T20:32:44.9479381+01:00",
      "Checksum": "EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47",
      "ChecksumStatus": "Valid"
    },
    {
      "Name": "SharePointDsc",
      "Version": "1.4.0.0",
      "Size": 441882,
      "Created": "2016-11-17T20:32:44.9634321+01:00",
      "Checksum": "35B1622E1890BAA2D529EDFB07285BEEFCFE8F8D3A4640FF785E1E30E64181A9",
      "ChecksumStatus": "Invalid"
    }
  ]
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Module doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/modules/SharePointDsc" -UseDefaultCredentials
  ```


### Get Module

Returns json data about a module.

* **URL**  
  /api/v1/modules/{name}/{version}

* **Method**  
  `GET`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*
  **version** `[string]` *REQUIRED*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  {
    "Name": "SharePointDsc",
    "Version": "1.3.0.0",
    "Size": 429285,
    "Created": "2016-11-17T20:32:44.9479381+01:00",
    "Checksum": "EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47",
    "ChecksumStatus": "Valid"
  }
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Module doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/modules/SharePointDsc/1.3.0.0" -UseDefaultCredentials
  ```


### Calculate Module Checksum

Updates the checksum of a single module.

* **URL**  
  /api/v1/modules/{name}/{version}/checksum

* **Method**  
  `GET`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*
  **version** `[string]` *REQUIRED*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  {
    "Name": "SharePointDsc",
    "Version": "1.3.0.0",
    "Size": 429285,
    "Created": "2016-11-17T20:32:44.9479381+01:00",
    "Checksum": "EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47",
    "ChecksumStatus": "Valid"
  }
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Module doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Patch -Uri "$api/modules/SharePointDsc/1.3.0.0/checksum" -UseDefaultCredentials
  ```


### Download Module

Download the module as MOF file. The file name is optional but usefull
when working with a web browser.

* **URL**  
  /api/v1/modules/{name}/{version}/download/{file}

* **Method**  
  `GET`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*
  **version** `[string]` *REQUIRED*
  **file** `[string]` *OPTIONAL*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  *Content of the ZIP file.*

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Module doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/modules/SharePointDsc/1.3.0.0/download" -OutFile 'C:\SharePointDsc_1.3.0.0.zip' -UseDefaultCredentials
  ```


### Upload Module

Update a new module.

* **URL**  
  /api/v1/modules/{name}/{version}

* **Method**  
  `PUT`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*
  **version** `[string]` *REQUIRED*

* **Data Parameters**  
  *Content of the ZIP file.*

* **Success Response (200 OK):**  
  ```json
  {
    "Name": "SharePointDsc",
    "Version": "1.3.0.0",
    "Size": 429285,
    "Created": "2016-11-17T20:32:44.9479381+01:00",
    "Checksum": "EBBE30927695ADAE86A989C2627653861563E81C98B855303EC92138A0212F47",
    "ChecksumStatus": "Valid"
  }
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Put -Uri "$api/modules/SharePointDsc/1.3.0.0' -InFile 'C:\SharePointDsc_1.3.0.0.zip" -UseDefaultCredentials
  ```


### Delete Module

Delete an existing module.

* **URL**  
  /api/v1/modules/{name}/{version}

* **Method**  
  `DELETE`

* **Query Parameters**  
  **name** `[string]` *REQUIRED*

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  Empty

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Error Response (404 NOT FOUND)**  
  Module doesn't exist.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method DELETE -Uri "$api/modules/SharePointDsc/1.3.0.0" -UseDefaultCredentials
  ```

## Nodes

### Get All Nodes (Id)

Returns json data about all nodes which were registered by ConfigurationId.

* **URL**  
  /api/v1/nodes/id

* **Method**  
  `GET`

* **Query Parameters**  
  None

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  [
    {
      "ConfigurationID": "DD34ADD4-DF15-4FC5-A922-B0B2D4E8809A",
      "TargetName": "192.168.144.62",
      "NodeCompliant": true,
      "Dirty": false,
      "LastHeartbeatTime": "2016-11-24T15:40:25.243",
      "LastComplianceTime": "2016-11-24T15:40:25.243",
      "StatusCode": 0,
      "ServerCheckSum": "3F660B4567B21A92EF715289036FCC282E9F834465040BEED7E716855A0DA04F",
      "TargetCheckSum": "3F660B4567B21A92EF715289036FCC282E9F834465040BEED7E716855A0DA04F"
    },
    {
      "ConfigurationID": "MyConfigName",
      "TargetName": "192.168.144.63",
      "NodeCompliant": true,
      "Dirty": false,
      "LastHeartbeatTime": "2016-11-24T15:40:25.702",
      "LastComplianceTime": "2016-11-24T15:40:25.702",
      "StatusCode": 0,
      "ServerCheckSum": "B49C830299D1B19A0860D01494E6E51755FD89E6FA63F8F8C6349F9D226F6888",
      "TargetCheckSum": "B49C830299D1B19A0860D01494E6E51755FD89E6FA63F8F8C6349F9D226F6888"
    }
  ]
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/nodes/id" -UseDefaultCredentials
  ```


### Get All Nodes (Names)

Returns json data about all nodes which were registered by ConfigurationNames.

* **URL**  
  /api/v1/nodes/names

* **Method**  
  `GET`

* **Query Parameters**  
  None

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  [
    {
      "AgentId": "f59847f8-424a-47c2-8fc7-151fe6acfdad",
      "NodeName": "LAB-DSC-NODE11",
      "LCMVersion": "2.0",
      "IPAddress": "192.168.144.64;127.0.0.1;fe80::1c06:7782:e09a:4a10%12;::2000:0:0:0;::1;::2000:0:0:0",
      "ConfigurationNames": [ "MySpecialConfig" ]
    },
    {
      "AgentId": "b0ca2747-b1dd-11e6-80bf-00155d67ca75",
      "NodeName": "LAB-DSC-NODE12",
      "LCMVersion": "2.0",
      "IPAddress": "192.168.144.63;127.0.0.1;fe80::21e3:3984:e9d2:4107%12;::2000:0:0:0;::1;::2000:0:0:0",
      "ConfigurationNames": [ "MyConfigName" ]
    }
  ]
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/nodes/names" -UseDefaultCredentials
  ```



## Reports


### Get All Reports

Returns json data about all reports.

* **URL**  
  /api/v1/reports

* **Method**  
  `GET`

* **Query Parameters**  
  None

* **Data Parameters**  
  None

* **Success Response (200 OK):**  
  ```json
  [
    {
      "Id": "DD34ADD4-DF15-4FC5-A922-B0B2D4E8809A",
      "JobId": "fdb22ac8-b253-11e6-80bf-00155d67ca74",
      "NodeName": "",
      "IPAddress": "",
      "RerfreshMode": "",
      "OperationType": "",
      "Status": "",
      "RebootRequested": true,
      "StartTime": "1899-12-30T00:00:00",
      "EndTime": "1899-12-30T00:00:00",
      "LastModifiedTime": "2016-11-24T15:40:50.503",
      "LCMVersion": "",
      "ConfigurationVersion": "",
      "ReportFormatVersion": "2.0",
      "Errors": [ "<<< Errors in JSON format. Output truncated!!! >>>" ],
      "StatusData": [],
      "AdditionalData": null
    },
    {
      "Id": "b0ca2747-b1dd-11e6-80bf-00155d67ca75",
      "JobId": "b0ca2748-b1dd-11e6-80bf-00155d67ca75",
      "NodeName": "LAB-DSC-NODE12",
      "IPAddress": "192.168.144.63;127.0.0.1;fe80::21e3:3984:e9d2:4107%12;::2000:0:0:0;::1;::2000:0:0:0",
      "RerfreshMode": "Pull",
      "OperationType": "LocalConfigurationManager",
      "Status": "Failure",
      "RebootRequested": true,
      "StartTime": "2016-11-24T01:34:05.58",
      "EndTime": "2016-11-24T01:34:17.58",
      "LastModifiedTime": "2016-11-24T15:30:43.833",
      "LCMVersion": "2.0",
      "ConfigurationVersion": "2.0.0",
      "ReportFormatVersion": "2.0",
      "Errors": [],
      "StatusData": [ "<<< Status data in JSON format. Output truncated! >>>" ],
      "AdditionalData": null
    }
  ]
  ```

* **Error Response (401 UNAUTHORIZED)**  
  You are not authorized to make this request.

* **Sample Call**
  ```powershell
  $api = 'https://localhost:8090/api/v1'
  Invoke-RestMethod -Method Get -Uri "$api/reports" -UseDefaultCredentials
  ```
