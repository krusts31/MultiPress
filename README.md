# MultiPress
I am trying to make a wordpress plugin so that I can have multiple langugaes for my woocomerce products

set up unit tests -> https://make.wordpress.org/cli/handbook/misc/plugin-unit-tests/

Now this has become my wordpress playground.

```bash
make dev
#will bring up a wordpress install with a fresh installation
make multi-dev
#will bring up wordpress multi site instalation
```

If you are deploying to the cloud then make sure to set staging to 0 if you get
a ssl ERROR. This will make certbot to create reall certificates.
