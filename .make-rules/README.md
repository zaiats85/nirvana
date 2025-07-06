# Make Rules

This is a collection of make-rules that are reusable across projects. Using them
is making it possible for all projects to benefit from further optimizations
of these rules.

These rules are heavily using the "convention-over-configuration" approach!
These conventions are (or should be) used in all of our projects, to make life
of us developers more easy and enjoyable! 🌴🍹🍻🏖️

## Before you start (no really... read this!)

There is some knowledge and external tooling that you should know about, making
the usage of these rules way clearer and your overall worklife more relaxing.

### Make Variables

Inside the rules you'll see patterns like these a lot:

```make
SOME_VARIABLE ?= somevalue

PHONY: some-target
some-target:
  echo $(SOME_VARIABLE)
```

This pattern means nothing more than "set the variable, if it is not set".
Sounds pretty easy, but with this there comes a great benefit:

We can use conventions in our make-rules, without dropping customizations!

And even better: Make will even notice when your system already has a
environment-variable set, that is matching the variable's name.

So in our example above, simply calling

```bash
make some-target
```

would output `somevalue` to your terminal.

But when we would do this in our terminal:

```bash
export SOME_VARIABLE=foobar
make some-target
```

the output to our terminal would be `foobar`.

Maybe you even know what our third example will be, but just to be sure:

When you want to change a variable only for one single call to a make-rule, you
easily can by calling the target like this:

```bash
make some-target SOME_VARIABLE=helloworld
```

#### Practical usage of Make Variables

We have a rule for the target `ghcr/login` in here. This rule is looking like
this:

```make
.PHONY: ghcr/login
ghcr/login:
	echo $(GHCR_TOKEN)|$(CONTAINER_MANAGER) login ghcr.io -u $(GITHUB_USERNAME) --password-stdin
```

As you can see, we are using 3 different variables here: `GHCR_TOKEN`,
`CONTAINER_MANAGER` and `GITHUB_USERNAME`. Of course, all of us are having
different usernames at github, and also our tokens to login differ. Some of us
are using docker as their container-manager, and others use podman.

So on my machine I have set this 3 variables as environment-variables, and by
doing so I can create a new Makefile with this content:

```make
-include $(MAKE_RULES_PATH)/ghcr.mk
```

and can now directly call `make ghcr/login` without passing any more variables
via terminal, and will be logged in to ghcr... easy right? 🎉

### direnv

As mentioned above, all (or at least most) of the variables used in our rules,
can be overwritten with environment-variables. But often these variables need
to be different between projects. This is where [direnv](https://direnv.net/) is
coming pretty handy. Personally I am using direnv _a lot_ and in more or less
every project I am working on.

Direnv is simply setting and unsetting environment-variables while you move
through directories in you terminal. As soon as it is finding a file named
`.envrc` in a directory, it will set the variables included in this file. It
will keep these variables in all child-directories. When you navigate to a
directory above, it will unset them:

```bash
mralexandernickel@workstation [17:24:04] [~]
-> % cd repos/flagbit
mralexandernickel@workstation [17:24:09] [~/repos/flagbit]
-> % cd touratech-k8s-helm-charts
direnv: loading /srv/git/flagbit/touratech-k8s-helm-charts/.envrc
direnv: export +AWS_ACCESS_KEY_ID +AWS_DEFAULT_REGION +AWS_SECRET_ACCESS_KEY +DOCKERCONFIGJSON +GHCR_TOKEN +KUBECONFIG
mralexandernickel@workstation [17:24:18] [~/repos/flagbit/touratech-k8s-helm-charts] [feature/TTNO-11]
-> % cd magento2
mralexandernickel@workstation [17:24:35] [~/repos/flagbit/touratech-k8s-helm-charts/magento2] [feature/TTNO-11]
-> % cd ..
mralexandernickel@workstation [17:24:37] [~/repos/flagbit/touratech-k8s-helm-charts] [feature/TTNO-11]
-> % cd ..
direnv: unloading
mralexandernickel@workstation [17:24:39] [~/repos/flagbit]
```

#### Practical usage of direnv

For example the `awscli` is able to read the tokens needed to connect to
aws-services from environment-variables. These tokens do differ from project
to project, when you now add an `.envrc` into the projects-repositories
(and add `.envrc` to the `.gitignore` of course!), you can use the `awscli`
directly, without needing to remember to set the right variables manually, or
pass them to the `awscli`-command as an extra parameter.

This is also making it possible to reuse these `awscli` commands between
projects (calling the same make-target), and get the desired output depending
on the project 🎉🚀

Here some output in my terminal showing this behavior:

```bash
mralexandernickel@workstation [17:42:32] [~/repos/flagbit]
-> % cd touratech-k8s-helm-charts
direnv: loading /srv/git/flagbit/touratech-k8s-helm-charts/.envrc
direnv: export +AWS_ACCESS_KEY_ID +AWS_DEFAULT_REGION +AWS_SECRET_ACCESS_KEY +DOCKERCONFIGJSON +GHCR_TOKEN +KUBECONFIG
mralexandernickel@workstation [17:42:39] [~/repos/flagbit/touratech-k8s-helm-charts] [feature/TTNO-11]
-> % aws iam get-user
{
    "User": {
        "Path": "/",
        "UserName": "flagbit-touratech",
        "UserId": "AIDAUHC3JC4K6H2Q7HFN7",
        "Arn": "arn:aws:iam::290101729045:user/flagbit-touratech",
        "CreateDate": "2020-08-31T14:35:44Z",
        "PasswordLastUsed": "2020-12-21T10:47:20Z",
        "Tags": [
            {
                "Key": "managed",
                "Value": "by Terraform"
            }
        ]
    }
}
mralexandernickel@workstation [17:42:42] [~/repos/flagbit/touratech-k8s-helm-charts] [feature/TTNO-11]
-> % cd ../flagbit.com
direnv: loading /srv/git/flagbit/flagbit.com/.envrc
direnv: export +AWS_ACCESS_KEY_ID +AWS_ACCOUNT_ID +AWS_DEFAULT_REGION +AWS_SECRET_ACCESS_KEY +CONTAINER_MANAGER +DOCKERCONFIGJSON +GITHUB_K8S_TOKEN +K8S_INGRESS_HOSTNAME +KUBECONFIG +MARIADB_ROOT_PASSWORD +MYSQL_PASSWORD +MYSQL_ROOT_PASSWORD +RELEASE_PLEASE_TOKEN +WORDPRESS_PASSWORD +WORDPRESS_USERNAME
mralexandernickel@workstation [17:43:03] [~/repos/flagbit/flagbit.com] [feature/WEBFLAG-77 *]
-> % aws iam get-user
{
    "User": {
        "Path": "/",
        "UserName": "alexander.nickel",
        "UserId": "AIDAJ7SUUEOGXDVYS7ITK",
        "Arn": "arn:aws:iam::700707183175:user/alexander.nickel",
        "CreateDate": "2017-04-26T09:25:37Z",
        "PasswordLastUsed": "2021-07-02T08:59:10Z"
    }
}
```

## How to use

In your project create (or extend an existing) Makefile. Inside of this
Makefile you'll need to add some variables, depending on the rules you want to
use. A very minimal example of a Makefile inside project/repository that is
holding sources for a container-image and should be released via
`github container registry`, could look like this:

```make
-include $(MAKE_RULES_PATH)/ghcr.mk
-include $(MAKE_RULES_PATH)/oci.mk
```
