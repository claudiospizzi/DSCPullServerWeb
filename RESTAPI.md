
# DSCPullServerWeb REST API



## Overview

Action                                                          | Method   | URI
---                                                             | ---      | ---
[Get All Configurations](#get-all-configurations)               | `GET`    | /api/v1/configurations
[Get Configuration](#get-configuration)                         | `GET`    | /api/v1/configurations/{name}
[Update Configuration Checksum](#update-configuration-checksum) | `GET`    | /api/v1/configurations/{name}/hash
[Download Configuration](#download-configuration)               | `GET`    | /api/v1/configurations/{name}/download/{file}
[Upload Configuration](#upload-configuration)                   | `PUT`    | /api/v1/configurations/{name}
[Delete Configuration](#delete-configuration)                   | `DELETE` | /api/v1/configurations/{name}



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
  Invoke-RestMethod -Method GET -Uri 'http://localhost:8090/api/v1/configurations' -UseDefaultCredentials
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
  Invoke-RestMethod -Method GET -Uri 'http://localhost:8090/api/v1/configurations/FeatureDemo' -UseDefaultCredentials
  ```


### Update Configuration Checksum

Updates the checksum of a single configuration.

* **URL**  
  /api/v1/configurations/{name}/hash

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
  Invoke-RestMethod -Method GET -Uri 'http://localhost:8090/api/v1/configurations/FeatureDemo/hash' -UseDefaultCredentials
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
  Invoke-RestMethod -Method GET -Uri 'http://localhost:8090/api/v1/configurations/FeatureDemo/download' -OutFile 'C:\Temp\FeatureDemo.mof' -UseDefaultCredentials
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
  Invoke-RestMethod -Method PUT -Uri 'http://localhost:8090/api/v1/configurations/FeatureDemo' -InFile 'C:\Temp\FeatureDemo.mof' -UseDefaultCredentials
  ```


### Delete Configuration

Delete n existing configuration.

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
  Invoke-RestMethod -Method DELETE -Uri 'http://localhost:8090/api/v1/configurations/FeatureDemo' -UseDefaultCredentials
  ```



