
# Get and dot source all helper functions (private)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Modules\DSCPullServerWeb\Helpers' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Modules\DSCPullServerWeb\Functions' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Update format data
Update-FormatData "$PSScriptRoot\..\Modules\DSCPullServerWeb\Resources\DSCPullServerWeb.Formats.ps1xml"

# Update type data
Update-TypeData "$PSScriptRoot\..\Modules\DSCPullServerWeb\Resources\DSCPullServerWeb.Types.ps1xml"

# Execute deubg
# ToDo...
