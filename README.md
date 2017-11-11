ReproNim Challenge

See available docker images:
`docker images`

<<<<<<< Local Changes
make the create_docker.sh

=======
Run docker image to fetch 15 male and 15 female brains, BET and do ttest on the Volume:
`docker run -it -v {path_to}/ReproNim_bet_SACY/:/home/neuro --rm myimage ./run_all.sh`
>>>>>>> External Changes

Typical git workflow:
```
git add new_script.sh
git commit -m "Created new_script.sh"
git push
```
