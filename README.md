This version of suppository exists to push releases to another repository using github workflows.


```

If you have any inquiries; file an issue with the github tracker.

pre-requisites: 
* must be able to use a text-editor (at very least) to make alterations to deploy to another repository.
* create two secrets in github settings:
* PAT_USER, containing the github account name belonging to the account you forked suppository with (example: borntohonk)
* PAT_TOKEN, containing a github token with repository permissions in the target repository you want to upload releases to.

```

Credits: [@borntohonk](https://github.com/borntohonk)
license: whichever applicable to whichever files and MIT on whatever else (not that there's anything worth licensing here)
