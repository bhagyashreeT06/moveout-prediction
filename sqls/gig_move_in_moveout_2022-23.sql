-- sql to fetch month wise movein and moveout
select
  start_month_year,
  count(start_month_year) total_move_in,
  count(move_out_month_year) total_move_out
from
  (
    select
      l.id,
      to_char(lp.lease_start_date, 'YYYY-MM-DD') as start_date,
      (
        CASE
          WHEN li.lease_status_type_id = 6 THEN to_char(lp.move_out_date, 'YYYY-MM-DD')
          ELSE NULL
        END
      ) as move_out_date,
      to_char(lp.lease_start_date, 'Mon-YY') as start_month_year,
      (
        CASE
          WHEN li.lease_status_type_id = 6 THEN to_char(lp.move_out_date, 'Mon-YY')
          ELSE NULL
        END
      ) as move_out_month_year
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
    where
      l.cid = 15077
      and lp.lease_start_date :: date > '2021-12-31'
      and lp.lease_start_date :: date < '2023-02-01'
      and li.lease_status_type_id in (4, 6, 5)
    order by
      start_date asc
  ) as temp
group by
  start_month_year
order by
  CASE
    start_month_year
    WHEN 'Jan-22' THEN 1
    WHEN 'Feb-22' THEN 2
    WHEN 'Mar-22' THEN 3
    WHEN 'Apr-22' THEN 4
    WHEN 'May-22' THEN 5
    WHEN 'Jun-22' THEN 6
    WHEN 'Jul-22' THEN 7
    WHEN 'Aug-22' THEN 8
    WHEN 'Sep-22' THEN 9
    WHEN 'Oct-22' THEN 10
    WHEN 'Nov-22' THEN 11
    WHEN 'Dec-22' THEN 12
    WHEN 'Jan-23' THEN 13
  END