# Brian Kintz
# 23.12.2014

command: "osascript 'nowplaying.widget/track_info.scpt'"

refreshFrequency: 2000

style: """
    bottom: 20px
    left: 270px
    width: 400px
    font-family: "Helvetica Neue"
    font-size: 9pt

    .nowplaying
        height: 50px
        padding: 9px 10px 10px 10px
        background: rgba(#000, 0.3)
        border-radius: 10px

    .artwork, .metadata
        display: inline-block

    .artwork
        float: left
        margin-right: 10px

    .title, .artist, .album
        height: 16px
        position: relative
        top: -1px
        overflow: hidden
        white-space: nowrap
        text-overflow: ellipsis

    .title
        color: #FFF
        font-weight: 600

    .artist
        color: rgba(#FFF, 0.9)

    .album
        color: rgba(#FFF, 0.6)

    .progress
        height: 2px
        margin-top: 3px
        background: rgba(#FFF, 0.6)

    .trackId
        display: none
"""

render: (_) -> """
    <div class="nowplaying">
        <embed class="artwork" width="44px" height="44px" type="image/tiff" />
        <div class="metadata">
            <div class="title"></div>
            <div class="artist"></div>
            <div class="album"></div>
        </div>
        <div class="progress"></div>
        <div class="trackId"></div>
    </div>
"""

update: (output, domEl) ->
    if output.trim() == "Not Playing"
        $(domEl).fadeOut 500
        $(domEl).data('playing', false)
    else
        $(domEl).fadeIn 500

        if !$(domEl).data('playing')
            artwork = $(domEl).find('.artwork')
            artwork.attr('src', artwork.attr('src') + '?' + new Date().getTime())
            $(domEl).data('playing', true)

        # { title, artist, album, progress, trackId }
        data = $.parseJSON(output)

        if (data.progress >= 0 and data.progress <= 100)
            # reset padding in case the last song's progress wasn't available (Spotify)
            if (data.progress < 3)
                $(domEl).find('.artwork, .metadata').css "padding-top": "0"
            $(domEl).find('.progress').css width: "#{data.progress}%"
        else
            $(domEl).find('.artwork, .metadata').css "padding-top": "2px"
            $(domEl).find('.progress').css width: "0%"


        previousId = $(domEl).find('.trackId').text()
        if previousId != data.trackId
            $(domEl).find('.trackId').text(data.trackId)

            $(domEl).find('.title').text(data.title)
            $(domEl).find('.artist').text(data.artist)
            $(domEl).find('.album').text(data.album)

            if data.player == "itunes"
                $(domEl).find('.artwork').show().attr('src', 'nowplaying.widget/artwork.tiff')

            else if data.player == "spotify"
                parts = data.trackId.split(":")

                # try to get artwork from the Spotify web API
                if (parts[1] == "track")
                    $.get("https://api.spotify.com/v1/tracks/#{parts[2]}", (data) ->
                        $(domEl).find('.artwork').show().attr('src', data.album.images[2].url)
                    ).fail(() ->
                        $(domEl).find('.artwork').hide()
                    )
                else
                    $(domEl).find('.artwork').hide()
            else
                $(domEl).find('.artwork').hide()