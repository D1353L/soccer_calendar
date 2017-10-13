window.onload=function(){
     $(function(){
         if(window.location.protocol==="https:")
             window.location.protocol="http";
     });
 }

$(document).ready(function () {
    LoadSoccerMatches(moment())

    $('#datetimepicker').datetimepicker({
        inline: true,
        sideBySide: true,
        format: "DD/MM/YYYY"
    });

    $("#datetimepicker").on("dp.change", function (e) {
        LoadSoccerMatches(e.date)
    })

    $('#refresh').on('click', function (e) {
        e.preventDefault()
        date = $(this).attr('data-date')
        Refresh(date)
    })

});

function LoadSoccerMatches(date)
{
    var stringDate = date.format('YYYY-MM-DD')
    $('#table').addClass("hidden")
    $('#message').empty()
    $('#table tbody').empty()
    $('#tableTitle').html("Soccer matches for " + stringDate)
    $('#refresh').attr("data-date", stringDate)

    $.getJSON("http://localhost:3000/api/v1/matches/" + stringDate, function(json) {
        if (json){
            if(json['message']){
                $('#message').html(json['message'])
            }
            else {
                $('#table').removeClass("hidden")

                var transform =
                 {"tag":"tr","children":[
                    {"tag":"td","html": "${date_time}"},
                    {"tag":"td","html":
                        "${scores.0.team} (${scores.0.country_code})"+
                        " - ${scores.1.team} (${scores.1.country_code})"
                    },
                    {"tag":"td","html": "${scores.0.goals_count} - ${scores.1.goals_count}"}
                ]};

                $('#table tbody').append(json2html.transform(json,transform))
            }

        }
    })
}

function Refresh(date){
    $.ajax({
      type: "POST",
      url: 'http://localhost:3000/api/v1/matches/refresh',
      data: {date: date}
    }).done(function() {
        LoadSoccerMatches(moment(date))
    });
}
