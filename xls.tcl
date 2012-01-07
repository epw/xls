#! /usr/bin/env wish

proc changedir {el} {
    if { $el == "row" } {
	return column
    } elseif { $el == "column" } {
	return row
    }
}

proc grid_defaults {slave row column {in "."}} {
    grid $slave -in $in -row $row -column $column -sticky n -ipadx 10
}

proc xls {{el row} {row 0} {column 0} {frame "."}} {
    foreach f [glob -nocomplain *] {
	set $el [expr $[set el] + 1]
	set entryname entry[regsub -all {[^A-Za-z0-9]} $f _]
	if { [file type $f] == "directory" } {
	    if { $el == "column" } {
		frame .frm$entryname
		grid_defaults .frm$entryname $row $column $frame
		set oldframe $frame
		set oldrow $row
		set oldcolumn $column
		set frame .frm$entryname
	    }
	    label .$entryname -text $f/ -relief groove
	    grid_defaults .$entryname $row $column
	    cd $f
	    set addition [xls [changedir $el] $row $column $frame]
	    set $el [expr $[set el] + $addition + 1]
	    cd ..
	    if { $el == "column" } {
		set frame $oldframe
	    }
	} else {
	    label .$entryname -text $f
	    grid_defaults .$entryname $row $column
	}
    }
    return [set [set el]]
}

proc usage_exit {name} {
    puts [concat "Usage: $name " {[directory]}]
    exit 1
}

if { $argc > 0 } {
    if { [lsearch -exact [list -h -? -help --help] [lindex $argv 0]] != -1} {
	usage_exit $argv0
    }
    if { ![file exists [lindex $argv 0]]
	 || [file type [lindex $argv 0]] != "directory" } {
	usage_exit $argv0
    }
    cd [lindex $argv 0]
}
xls
