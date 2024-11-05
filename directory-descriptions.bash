################################################################                                                                                                                                                                                                                                                          
################## directory-descriptions.bash #################                                                                                                                                                                                                                                                          
################## an offering from librecell  ## GPLv3full+ ###                                                                                                                                                                                                                                                          
################################################################                                                                                                                                                                                                                                                          

# add to ~/.bashrc or source with `source /path/to/directory-descriptions.bash`                                                                                                                                                                                                                                           

# environment variable to control showing directory descriptions                                                                                                                                                                                                                                                          
export show_dir_description=1  # default to enabled                                                                                                                                                                                                                                                                       
export dir_description_color=4 # 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white                                                                                                                                                                                                                    

# toggle show_dir_description on or off                                                                                                                                                                                                                                                                                   
toggle_dir_descriptions() {
    case "$1" in
        [yY1]*) export show_dir_description=1; echo "directory descriptions enabled." ;;
        [nN0]*) export show_dir_description=0; echo "directory descriptions disabled." ;;
        *) echo "usage: toggle_dir_descriptions [y/n]" ;;
    esac
}

# display description if ..directory file exists in current directory                                                                                                                                                                                                                                                     
show_if_hidden_file_exists() {
    local show_dir_name="$1"  # pass "yes" to print $PWD in color, "no" to skip                                                                                                                                                                                                                                           

    if [[ "$show_dir_description" -eq 1 ]]; then
        local hidden_file="..$(basename "$PWD")"  # hidden file named after current directory with ".." prefix                                                                                                                                                                                                            
        if [[ -f "$hidden_file" ]]; then
            # Show PWD in color if called by cd and color is enabled                                                                                                                                                                                                                                                      
            if [[ "$show_dir_name" == "yes" && "$dir_description_color" -ne 0 && "$dir_description_color" -ne 7 && "$TERM" == *color* ]]; then
                echo -e "\033[1;3${dir_description_color}m$PWD"
                cat "$hidden_file"
                echo -ne "\033[0m"
            else
                [[ "$show_dir_name" == "yes" ]] && echo "$PWD"
                # Color description when TERM supports color, even if called by pwd                                                                                                                                                                                                                                       
                if [[ "$dir_description_color" -ne 0 && "$dir_description_color" -ne 7 && "$TERM" == *color* ]]; then
                    echo -ne "\033[1;3${dir_description_color}m"
                    cat "$hidden_file"
                    echo -ne "\033[0m"
                else
                    cat "$hidden_file"
                fi
            fi
        fi
    fi
}

# alias 'cd' to include the function call and print $PWD in color                                                                                                                                                                                                                                                         
cd() {
    builtin cd "$@" && show_if_hidden_file_exists "yes"
}

# extend 'pwd' to include the function call, without printing $PWD again                                                                                                                                                                                                                                                  
pwd() {
    builtin pwd && show_if_hidden_file_exists "no"
}


################################################################                                                                                                                                                                                                                                                          
### GPLv3full+ ## an offering from librecell ###################                                                                                                                                                                                                                                                          
################################################################

