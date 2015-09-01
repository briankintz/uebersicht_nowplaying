tell application "System Events"
	if exists process "Spotify" then
		tell application "Spotify"
			if player state is playing then
				set t to current track
				
				return my buildMetadataString("spotify", name of t, artist of t, album of t, (duration of t) / 1000, player position, id of t)
			end if
		end tell
	end if
	
	if exists process "iTunes" then
		tell application "iTunes"
			if player state is playing then
				set t to current track
				
				try
					set a to data of artwork 1 of t
					
					if player position is less than 3 then
						my setCurrentAlbumArtwork(a)
					end if
				on error
					set hasArtwork to false
				end try
				
				return my buildMetadataString("itunes", name of t, artist of t, album of t, duration of t, player position, persistent ID of t)
			end if
		end tell
	end if
	
	return "Not Playing"
end tell

on buildMetadataString(player, title, artist, album, duration, position, trackId)
	set progress to (100 * position / duration) as integer
	
	return "{ \"player\": \"" & player & "\", \"title\": \"" & title & "\", \"artist\": \"" & artist & "\", \"album\": \"" & album & "\", \"progress\": " & progress & ", \"trackId\": \"" & trackId & "\" }"
end buildMetadataString

on setCurrentAlbumArtwork(artwork)
	set artworkFilePath to ((path to home folder) as text) & "Library:Application Support:†bersicht:widgets:nowplaying.widget:artwork.tiff" as alias
	set fileHandle to (open for access artworkFilePath with write permission)
	try
		write artwork to fileHandle
		close access fileHandle
	on error errorMsg
		try
			close access fileHandle
		end try
		error errorMsg
	end try
	
	tell application "Finder" to set creator type of artworkFilePath to "????"
end setCurrentAlbumArtwork