# Refresh from original Repo
# WARNING will remove all local changes!!!
# except for files not in Git

git fetch --all
git reset --hard origin/master

# Pull in submodules like Stetl
git submodule foreach git pull origin master
