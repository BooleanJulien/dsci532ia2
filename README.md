# Practice Deployment of Dash-R app to Heroku

This repo contains the individual assignment 2 for DSCI 532 for Julien Gordon
The deployed app is hosted here https://dsci532ia2junigo.herokuapp.com/.

Steps used to reproduce:

1. `git clone git@github.com:UBC-MDS/dashr-heroku-deployment-demo.git`
2. `cd dashr-heroku-deployment-demo`
3. `heroku create --stack container your-heroku-site`
4. `git push heroku main`
5. Wait ~15 min for the build to finish.
6. `heroku ps:scale web=1`
7. Navigate to `https://you-heroku-site.herokuapp.com` in your browser
