use github.com/SethCurry/elvish-libs/hugo

fn -root {
    if (has-env NOTES_ROOT) {
        put $E:NOTES_ROOT
        return
    }
    put "~/.notes"
}

fn -notes-root {
    put (-root)/content
}

fn -file-exists [path]{
    eq (bool ?(test -f $path)) $true
}

fn -dir-exists [path]{
    eq (bool ?(test -d $path)) $true
}

fn -editor {
    if (has-env EDITOR) {
        put $E:EDITOR
    } else {
        put "vim"
    }
}

fn -create-note [title path]{
    note_dir=(dirname $path)

    mkdir -p $note_dir

    echo "---" > $path
    echo "title: \""$title"\"" >> $path
    echo 'description: ""' >> $path
    echo 'categories: []' >> $path
    echo 'tags: []' >> $path
    echo "---" >> $path
}

fn -create-folder [path]{
    folder_name=(basename $path)

    mkdir -p $path

    index_path=$path/_index.md

    echo "---" > $index_path
    echo "title: \""$folder_name"\"" >> $index_path
    echo "---" >> $index_path
}

fn -dir-has-index [dirpath]{
    -file-exists $dirpath/_index.md
}

fn -edit-file [path]{
    (external (-editor)) $path
}

fn -note-dir [name]{
    put (-notes-root)/$name
}

fn -note-path [name]{
    put (-note-dir $name)".md"
}

fn edit [name]{
    note_path=(-note-path $name)


    if (not (eq (-file-exists $note_path) $true)) {
        note_dir=(dirname $name)
        while (not (eq $note_dir ".")) {
            if (not (eq (-dir-has-index $note_dir) $true)) {
                -create-folder (-note-dir $note_dir)
            }
            note_dir=(dirname $note_dir)
        }

        -create-note (basename $name) $note_path
    }
    -edit-file $note_path
}

fn ls {
    tree -I "_index.md" -C (-notes-root) | sed 's/.md//g'
}

fn serve {
    hugo:serve (-root)
}
