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
	    label .$entryname -text $f/ -font {TkDefaultFont 10 bold} -relief groove
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

if { $argc > 0 } {
    cd [lindex $argv 0]
}
xls
