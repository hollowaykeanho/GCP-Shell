# CONTRIBUTING GUIDELINES
First and foremose, thanks for your interest in contributing to this repository.
This section lists out all the guidelines for having a smooth upstream.




## General Repository Rules
Here are some of the general repository rules for every contributors to comply
with in order to maintain the repository easily.




### 1. Use `next` Branch for Development
The `next` branch is meant for development. Hence, as a contributor, please
ensure your codes are compatible with it.

The `staging` branch is the next version of `main` branch while the `main`
branch is the released version. Leave those 2 branches to the maintainers.




### 2. Specify Everything into Git Commit Message
Instead of relying on issues section, please **keep all the contribution data,
descriptions, motivation, summary of what it does into your git commit
message**.

Although GitLab provides a very versatile platform for managing git repository,
a lot of time, both Github and GitLab are bad at retaining repository
information into the Git repository itself. That's why it's best we do it from
the get-go, 1-time effort instead.

Here is a pattern (not a rule) for a good git message:

```
<directory/file>: <short title of the commit>
<What is the problem: Describe it in details. You can paste the data here if
available so that one can just look at the commit messsage to understand why
are you doing it>

<Why the patch is needed: Specify why this patch is needed to solve the
problem.><How the patch solves the work: summarize your approach in solving
the problem without specifying the entire codes. We can see the code changes
below.>

This patch does <elaborate the action of the patch again. This is useful when
short title is insufficient enough to describe it>


Signed-off by: <Your, Name> <<Your Email>>
```

Example:

```
compute-firewall-rules-allowHTTP-create.sh: corrected filename typo

The file has a typo where create became crete. Hence, we should rename it
accordingly.

This patch corrects filename typo in compute-firewall-rules-allowHTTP-create.sh.


Signed-off-by: (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
```




### 3. Ensure Your Codes Has License Headers
Not all codes in this repository are
[MIT Licensed](https://gitlab.com/holloway/gcp/-/blob/next/LICENSE). Hence,
you need to make sure your every code files contain the license header.

In short, the repository is licensed under MIT License to promote learning.
If the source codes you learnt has its original license header, please retain
it so that everyone knows what to deal with it.

See https://gitlab.com/holloway/gcp/-/blob/next/cases/bigquery-app-script.gs
as a case study.




### 4. Comply to Best Practices
Since this is a learning repository (e.g. your scribed notes during a lecture)
that has the ability to photostat itself into many copies instantly, it's best
we comply to best practices.

That way, people will not need to re-learn things again. (Psst: it's a painful
experience. I been through it.)




### 5. Make Sure Your GPG Is Available To Sign Commit
To ensure you are you (a security measure), please make sure you set your GPG
before commiting. You will need it for signing your patch and for verification
when pushing the commits into the repository.




## Questions / Discussion
Well, since this is a note scribing repository, please feel free to create
issue ticket in the repository's
[Issues Section](https://gitlab.com/holloway/gcp/-/issues). It should be fine.
