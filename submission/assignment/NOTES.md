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

## Task 7

7.1 => The problem is: Year and Month functions inside a where scan every row => bad performance
Logical Reads Before : 1006
Logical Reads After : 13

![7.1 before](screenshots/task07/7.1_before.png)

![7.1 after](screenshots/task07/7.1_after.png)

7.2 => The problem is: DATEDIFF Reads through all the rows
Logical Read Before: 599
Logical Reads After: 76

![7.2 before](screenshots/task07/7.2_before.png)

![7.2 after](screenshots/task07/7.2_after.png)

7.3 => The problem is: LEFT Reads through all the rows
Logical Read Before: 1267
Logical Reads After: 20

![7.3 before](screenshots/task07/7.3_before.png)

![7.3 after](screenshots/task07/7.3_after.png)

7.4 => The problem is: Id + 1 makes SQL calculate this value for all of the rows
Logical Read Before: 130937
Logical Reads After: 4

![7.4 before](screenshots/task07/7.4_before.png)

![7.4 after](screenshots/task07/7.4_after.png)

7.5 => The problem is: using N'' while the type is varchar makes it converts all the rows
Logical Read Before: 725
Logical Reads After: 3

![7.5 before](screenshots/task07/7.5_before.png)

![7.5 after](screenshots/task07/7.5_after.png)

7.6 => The problem is: UPPER scan through all of the rows while not using it will give the same result
Logical Read Before: 1006
Logical Reads After: 3

![7.6 before](screenshots/task07/7.6_before.png)

![7.6 after](screenshots/task07/7.6_after.png)

7.7 => The problem is: The plan sql uses plan that work even if @LastName is null
Logical Read Before: 1267
Logical Reads After: 18

![7.7 before](screenshots/task07/7.7_before.png)

![7.7 after](screenshots/task07/7.7_after.png)

7.8 => The problem is: using CONCAT scans all of the rows
Logical Read Before: 1267
Logical Reads After: 18

![7.8 before](screenshots/task07/7.8_before.png)

![7.8 after](screenshots/task07/7.8_after.png)

## Task 8

I sorted the non-deleted users by last name. With a table variable, SQL Server estimated about 292 rows, but the sort got 68,323. It ran out of its granted memory and spilled to `tempdb`.

![Sort spill warning](screenshots/task08/08_spill_warning.png)

I ran the same query with a `#temp` table. SQL Server could use statistics on `IsDeleted`, so it estimated 68,323 rows and gave the sort enough memory. The warning disappeared.

![Sort after the fix](screenshots/task08/08_fixed_no_warning.png)

## Task 9

`DISTINCT LastName` scanned 85,403 rows. Hash Match returned 62 distinct names.

![DISTINCT on LastName](screenshots/task09/09_distinct_no_index.png)

`DISTINCT Id` since Primary Key is already indexed so the plan goes directly to select

![DISTINCT on Id](screenshots/task09/09_distinct_unique_column.png)

## Task 10

I may use numbers when database creates all the rows, also numerics take less space in indexes unlike GUID which takes 16 bytes, the Tradeoff of numbers is predictability.

I may use GUID when needing non-predictable IDs.
