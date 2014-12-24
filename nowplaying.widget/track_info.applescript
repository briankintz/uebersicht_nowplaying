-- Brian Kintz
-- 23.12.2014

tell application "System Events"
	if exists process "Spotify" then
		tell application "Spotify"
			if player state is playing then
				set t to current track
				
				if player position is less than 3 then
					my setCurrentAlbumArtwork(artwork of t)
				end if
				
				return my buildMetadataString(name of t, artist of t, album of t, duration of t, player position, true)
			end if
		end tell
	end if
	
	if exists process "iTunes" then
		tell application "iTunes"
			if player state is playing then
				set t to current track
				
				try
					set a to data of artwork 1 of t
					set hasArtwork to true
					
					if player position is less than 3 then
						my setCurrentAlbumArtwork(a)
					end if
				on error
					set hasArtwork to false
				end try
				
				return my buildMetadataString(name of t, artist of t, album of t, duration of t, player position, hasArtwork)
			end if
		end tell
	end if
	
	return "Not Playing"
end tell

on buildMetadataString(title, artist, album, duration, position, hasArtwork)
	set progress to (100 * position / duration) as integer
	return title & "~~" & artist & "~~" & album & "~~" & progress & "~~" & hasArtwork
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