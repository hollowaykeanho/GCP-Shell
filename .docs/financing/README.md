# Managing Finances in Google Cloud Platform
This section covers all about costing, budgeting, optimizing, and implementing
money related matters in Google Cloud Platform. There are many topics to be
covered so this document will be updated from time-to-time.

Unlike others, there are no codes in this section. Most of them are set of
documents to be implemented in GUI.




## See Project/Organization Billing
To view project/organization billing status you navigate from:
```
Nav Menu > Billing > Billing > Billing Overview
```




## Manage Users for Billing
To manage/administrate members to manage billing accounts, you navigate from:
```
Nav Menu > IAM
```




## Invoice Data
Inovice data is about what you owe; billing report is where they were being
charged to. A few things you need to watch out is:

```
1. Invoice number - tracking ID
2. Invoice date - date of invoice
```




## Setting Budget
Setting a budget to receive alert notification for usage (when hit or
went over budget).

It's inside:

```
Biling > Budgets & Alerts
```

You can specify amount which is a fixed amount allocated from your finance.
Otherwise, you can use `last month` which adopt from last month.

Check credits for discount reduction report.

Then, you can set alert like thresholding (both actual amount or forecasted
amount).




## Setting Quota
This is to set a quota on resources. Budget is to alert and notify while quota
set the limit on use. There are 2 types:

1. Allocation
2. Rate

Some known abuses would be:

1. Unmonitored BigQuery




## Committed Use Discount (Long Term Contract Use)
Commited use discount allows you to save as high as 70% cost over commiting
n year of use.

You need to:

1. Identify what are the eligible resources for commitment (stable and
   predictable).

To visualize commitment vs. actual use, it's inside "Commitment Report". This
allows one to observe any resources is underutilized or making sense to purchase
commitment.




## Setting Up Advanced Cost Controls
Controlling resources cost defenses allow one to avoid surprising cost spike.
Common way is to use Pub/Sub.

Some overdriving would be:
1. Over-provisioned resources
2. Idle and part-time idle
3. Large expensive provision (e.g. 32 vcpu)




## Optimization
To ensure cost are in control, you need to optimize your usage. A few tools are:

1. Stackdriver
2. Remove unused IP addresses
3. Remove unused / orphaned persistent disks
4. Optimize Google Cloud Storage
5. Network speed optimization
