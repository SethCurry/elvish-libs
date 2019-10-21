OUTPUT = "stderr"

fn set-output [path]{
    OUTPUT = path
}

fn -write [formatted]{
    message=(to-json $formatted)
    if ($OUTPUT == "stderr") {
        echo $message >2
    } else if ($OUTPUT == "stdout") {
        echo $message
    } else {
        echo $message >> $OUTPUT
    }
}

fn -format-message [level message @rest]{
    put [&time=(date --rfc-3339='seconds') &level=$level &message=message &fields=@rest]
}

fn info [message @rest]{
    -write (-format-message "INFO" $message @rest)
}