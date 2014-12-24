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
        display: inline

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
    </div>
"""

update: (output, domEl) ->
  if output.trim() == "Not Playing"
    $(domEl).fadeOut 500

  else
    $(domEl).fadeIn 500

    previousTitle = $(domEl).find('.title').html()

    # { title, artist, album, progress, hasArtwork }
    values = output.split("~~")

    $(domEl).find('.progress').css width: values[3]+'%'

    if previousTitle != values[0]
        $(domEl).find('.title').html(values[0])
        $(domEl).find('.artist').html(values[1])
        $(domEl).find('.album').html(values[2])

        if values[4].trim() == "true"
            $(domEl).find('.artwork').show().attr('src', 'nowplaying.widget/artwork.tiff')
        else
            $(domEl).find('.artwork').hide()

