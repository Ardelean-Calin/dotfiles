function tmp --description "Create a temporary directory and navigate to it."
    cd $(mktemp -d)
end
