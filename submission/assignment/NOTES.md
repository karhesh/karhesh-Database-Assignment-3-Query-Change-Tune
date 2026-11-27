## Task 6

Prediction: SELECT <= HASH JOIN <= SORT<= CLUSTERED INDEX SCAN

The query returned 15 rows. It used 124 ms of CPU and took 178 ms to run. Parsing and compilation took 42 ms.

Invoices had 13 scan starts, 2,674 logical reads, 3 physical reads, and 2,538 read-ahead reads. StudentProfiles had a scan count of 0, with 450 logical reads, 61 physical reads, and 0 read-ahead reads. Both worktables reported zero reads.

![I/O and time](screenshots/task06/06_statistics_io_time.png)
![Actual plan](screenshots/task06/06_actual_plan.png)

### Operators:

Clustered Index Scan: Scanned the invoice index because the filters check the due date and compare two amounts. It read 146,801 rows and passed 50,427, against 43,532 estimated. The scan had no required order.

![Clustered Index Scan](screenshots/task06/06_prob_clusteredIS.png)

Compute Scalar: Calculated `TotalAmount - PaidAmount` as `Expr1002` so the next step could sort by the balance.

![Compute Scalar for Remaining](screenshots/task06/06_prob_scalar.png)

Sort: Ordered each worker’s rows by `Expr1002 DESC` so the largest balances came first.

![Sort](screenshots/task06/06_prob_sort.png)

Nested Loops: Passed each candidate invoice’s `StudentId` to the student lookup. That ID is the outer reference.

![Nested Loops](screenshots/task06/06_prob_nestedloop.png)

Clustered Index Seek: Used `sp.Id = i.StudentId` to find the student by primary key and return `StudentNumber`.

![Clustered Index Seek](screenshots/task06/06_prob_clusteredindexseek.png)

Gather Streams: Combined the workers’ results and kept them in balance order for Top.

![Gather Streams](screenshots/task06/06_prob_parallelism.png)

Top: Took the first 15 rows. The expression is a fixed count.

![Top](screenshots/task06/06_prob_top.png)

Compute Scalar (Urgency): Used the due date to label the final rows `Urgent` or `Normal`.

![Compute Scalar for Urgency](screenshots/task06/06_prob_computescalar.png)

SELECT: Returned the result. The plan shows 12 parallel workers, a 14 MB memory grant, and a 56 KB cached plan.

![SELECT properties](screenshots/task06/06_prob_select.png)

