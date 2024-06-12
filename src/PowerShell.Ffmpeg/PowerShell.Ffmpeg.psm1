$ErrorActionPreference = 'Stop'

<#
.SYNOPSIS
Creates Jellyfin-optimized media file.
#>
function ConvertTo-Jellyfin {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Path,

        [Parameter(Position = 1)]
        [string]
        $OutFile,

        [Parameter()]
        [int[]]
        # List of stream indicies to include in the output.
        # Default is all.
        $Stream
    )

    if(-not $OutFile) {
        $OutFile = [System.IO.Path]::ChangeExtension($Path, 'mp4')
    }

    $dir = Split-Path $OutFile -Parent

    if(-not (Test-Path $dir -PathType Container)) {
        New-Item $dir -ItemType Directory
    }

    if(Test-Path $dir -PathType Container) {
        if($Stream) {
            $s = $Stream | ForEach-Object { "-map", "0:$_" }
        }
        else {
            $s = '-map', '0:v', '-map', '0:a'
        }

        ffmpeg -i $Path `
            -c:v libx264 -preset veryfast -crf 23 `
            -profile:v high -level 4.1 -pix_fmt yuv420p `
            -vf "scale=-2:720" `
            -c:a aac -b:a 192k -ac 2 -ar 48000 `
            $s `
            $OutFile
    }
}
