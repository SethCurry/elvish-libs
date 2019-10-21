OUTPUT = "stderr"

fn set-output [path]{
    OUTPUT = $path
}

fn -write [formatted]{
    message=(put $formatted | to-json)
    if (eq $OUTPUT "stderr") {
        echo $message >&2
    } elif (eq $OUTPUT "stdout") {
        echo $message
    } else {
        echo $message >> $OUTPUT
    }
}

fn -format-message [level message fields]{
    out=[&time=(date --rfc-3339='seconds') &level=$level &message=$message]

    if (not-eq $fields []) {
        for key (keys $fields) {
            out=(assoc $out $key $fields[$key])
        }
    }

    put $out
}

fn debug [message fields]{
    -write (-format-message "DEBUG" $message $fields)
}

fn info [message fields]{
    -write (-format-message "INFO" $message $fields)
}

fn warn [message fields]{
    -write (-format-message "WARN" $message $fields)
}

fn error [message fields]{
    -write (-format-message "ERROR" $message $fields)
}