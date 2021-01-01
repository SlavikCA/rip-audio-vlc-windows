cd "FOLDER TO SAVE FILES TO"
@ECHO OFF
for /f "delims=" %%a in ('wmic OS get localdatetime  ^| find "."') do set datetime=%%a

set "YYYY=%datetime:~0,4%"
set "MM=%datetime:~4,2%"
set "DD=%datetime:~6,2%"
set "HH=%datetime:~8,2%"
set "MI=%datetime:~10,2%"
set "SS=%datetime:~12,2%"

set fullstamp=%YYYY%-%MM%-%DD%-%HH%-%MI%-%SS%
echo creating folder %fullstamp%
md %fullstamp%
cd %fullstamp%

    setlocal ENABLEDELAYEDEXPANSION

    SET /a x=0

    FOR /R D:\ %%G IN (*.cda) DO (CALL :SUB_VLC "%%G")
    powershell (New-Object -com "WMPlayer.OCX.7").cdromcollection.item(0).eject()
    GOTO :eof
	
    :SUB_VLC
    call SET /a x=x+1

    ECHO Transcoding %1

    CALL "C:\Program Files (x86)\VideoLAN\VLC\vlc" -I http cdda:///D:/ --cdda-track=!x! :sout=#transcode{vcodec=none,acodec=mp3,ab=128,channels=2,samplerate=44100}:std{access="file",mux=raw,dst="Track!x!.mp3"} --noloop vlc://quit

    :eof
