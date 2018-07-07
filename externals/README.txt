External modules are linked here.
These are Git Submodules.

To initially checkout Stetl:
cd ..
git submodule update --init --recursive

To update Stetl:
cd ..
git submodule update --recursive


More information about submodules:
git help submodule

To update to latest master version:

cd stetl
git fetch
git merge origin/master


To make changes in NLX GitHub, updating Stetl Submodule to latest Stetl master:

cd stetl
git checkout master && git pull
cd ..
git add stetl
git commit -m "updating Stetl to latest”
git push
