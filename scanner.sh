#! /bin/bash

clone() {
    rm -rf ./_output/$project_name
    git clone $project_url.git ./_output/$project_name
    cd ./_output/$project_name
    git checkout $version
    rm -rf ./vendor
    cd $current_path
}

scan() {
    docker run -v $PWD/:/project registry.nordix.org/cloud-native/meridio/scancode-toolkit:latest -clipeu --json-pp /project/_output/scan-report-$project_name.json /project/_output/$project_name
}

report() {
    dependencies=$(cat ./_output/scan-report-$project_name.json | jq -r '.files[] | select(.detected_license_expression_spdx != null) | [.path,.detected_license_expression_spdx] | @tsv')
    echo "$dependencies" > ./_output/simplified-report-$project_name.txt
    gpl=$(echo "$dependencies" | grep -i "gpl")
    echo "$gpl" > ./_output/simplified-report-$project_name-gpl.txt
}

all() {
    project_list=$(cat $PROJECTS_FILE)
    while IFS= read -r project; do
        project_url=$(echo "$project" | awk '{print $1}')
        main_lisence=$(echo "$project" | awk '{print $2}')
        version=$(echo "$project" | awk '{print $3}')
        project_name=$(echo "$project" | awk '{print $4}')
        echo "Scanning: $project_name $version $main_lisence $project_url ..."
        clone
        scan
        report
    done <<< "$project_list"
}

PROJECTS_FILE=${PROJECTS_FILE:-"list.txt"}

current_path=$(pwd)

all