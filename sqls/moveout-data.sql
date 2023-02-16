-- Propereties Used :
-- 754150		  Avana Eldridge				    12903
-- 714314 		Avana Rancho Cucamonga		8879
----------------------------------------------
-- Lease status
-- current : 4, past : 6, future : 3
-----------------------------------
-- dont include lease type 
-- Standard : 1
----------------------------------
-- propety details
select
  *
from
  properties
where
  id in (754150, 714314);

--------------------------------------------------------
-- leases
select
  l.id,
  l.primary_customer_id,
  l.active_lease_interval_id
from
  leases as l
where
  cid = 15077
  and property_id = 754150
  and id = 13096597;

-----------------------------------------------------------
-- lease type
select
  *
from
  lease_details
where
  lease_id = 13096730;

-----------------------------------------------------------
-- actie lease interval/status
select
  *
from
  lease_intervals
where
  id = 15866275;

-----------------------------------------------------------
-- customer details like name
select
  *
from
  customers
where
  id = 17174386;

--------------------------------------------------------------
-- lease process details : compare moveout date
select
  *
from
  lease_processes
where
  lease_id = 13096597;

---------------------------------------------------------------
-- Actual sql to fetch data for single property, 
-- just change propety id in the second last row
select
  l.id,
  (
    CASE
      WHEN c.name_first is null
      and c.name_last is null THEN c.company_name
      ELSE CONCAT(c.name_first, ' ', c.name_last)
    END
  ) as name,
  to_char(lp.lease_start_date, 'YYYY-MM-DD') as start_date,
  (
    CASE
      WHEN li.lease_status_type_id = 6 THEN to_char(lp.move_out_date, 'YYYY-MM-DD')
      ELSE NULL
    END
  ) as move_out_date,
  to_char(li.lease_end_date, 'YYYY-MM-DD') as end_date,
  CASE
    WHEN li.lease_status_type_id = 6 THEN 1
    ELSE 0
  END as moved_out
from
  leases as l
  join lease_details as ld on (
    ld.cid = l.cid
    and ld.lease_id = l.id
  )
  join lease_intervals as li on (
    li.cid = l.cid
    and li.id = l.active_lease_interval_id
  )
  join (
    select
      lease_id,
      min(move_in_date) as lease_start_date,
      max(move_out_date) as move_out_date
    from
      lease_processes
    where
      cid = 15077
    group by
      lease_id
  ) as lp on (lp.lease_id = l.id)
  join customers as c on (
    c.cid = l.cid
    and c.id = l.primary_customer_id
  )
where
  l.cid = 15077
  and l.property_id = 714314
  and li.lease_status_type_id in (3, 4, 6)