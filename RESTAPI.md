
# DSCPullServerWeb REST API

## Get All Configurations

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
  You are unauthorized to make this request.

* **Sample Call**
  ```powershell
  Invoke-RestMethod -Method GET -Uri 'http://localhost:8090/api/v1/configurations' -UseDefaultCredentials
  ```
