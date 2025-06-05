### Настроечные SET
#### SET10 Типы транзакций ДБО и их категории
-- DATE_FIELDS:
select name, category from transaction_type;

#### SET20 Интеграционные параметры
-- DATE_FIELDS:
select value_code, value from settings;

#### SET30 Настройки флагов
-- DATE_FIELDS:
select value_code, value_col, data_type from flag_settings;

#### SET40 Параметры обработки событий
-- DATE_FIELDS:
select a_dak,
       auto_decision,
       check_rule_mask,
       increased_load,
       priority,
       r_dak,
       rule_expression,
       threshold_amount,
       transaction_severity,
       ch.name as dbo_channel_name,
       cg.name as client_group_name,
       tt.name as transaction_type_name
from AUTENTIF_AND_AUTO_DECISION_SETTINGS ad
left join dbochannel ch on ad.channel_fk = ch.id
left join clientgroup cg on ad.client_group_fk = cg.id
left join transaction_type tt on ad.transaction_type_fk = tt.id;

---

### количественные CNT
#### CNT10 количество объектов в бд
-- DATE_FIELDS:
select 'payment_transaction_count', count(1) from payment_transaction
union all
select 'client_authentication_count', count(1) from client_authentication
union all
select 'client_count', count(1) from client
union all
select 'unique_device_count', count(1) from unique_device
union all
select 'device_config_type_count', count(1) from device_config_type
union all
select 'quarantine_list_count', count(1) from quarantine_list
union all
select 'quarantine_location_count', count(1) from quarantine_location;

---

### распределения DST
#### DST10 Самые частые клиенты в платежах ДБО
-- DATE_FIELDS: pt.document_save_timetamp
select c.dbo_id, count(1)
from payment_transaction pt
left join client c on pt.client_fk = c.id
where pt.document_save_timetamp >= '__START__'
  and pt.document_save_timetamp <= '__END__'
group by c.dbo_id
having count(1) > 10
order by count(1) desc limit 100;

#### DST20 Сколько платежей ДБО на одного клиента ДБО
-- DATE_FIELDS: pt.document_save_timetamp
with pay_by_client_dbo_id as (
    select c.dbo_id as h, count(1) as cnt
    from payment_transaction pt
    left join client c on pt.client_fk = c.id
    where pt.document_save_timetamp >= '__START__'
      and pt.document_save_timetamp <= '__END__'
    group by c.dbo_id
)
select avg(cnt), min(cnt), max(cnt) from pay_by_client_dbo_id;

#### DST30 Типы платежей
-- DATE_FIELDS: document_save_timetamp
select dtype, count(1)
from payment_transaction
where document_save_timetamp >= '__START__'
  and document_save_timetamp <= '__END__'
group by dtype;

#### DST40 сколько аутентификаций ДБО на один device hash
-- DATE_FIELDS: ca.auth_timestamp
with auth_by_hash as (
    select u.device_hash as h, count(1) as cnt
    from client_authentication ca
    left join unique_device u on ca.unique_device_fk = u.id
    where ca.auth_timestamp >= '__START__'
      and ca.auth_timestamp <= '__END__'
    group by u.device_hash
)
select avg(cnt), min(cnt), max(cnt) from auth_by_hash;

#### DST50 сколько аутентификаций ДБО на один imsi операций
-- DATE_FIELDS: ca.auth_timestamp
with auth_by_imsi as (
    select u.imsi as h, count(1) as cnt
    from client_authentication ca
    left join unique_device u on ca.unique_device_fk = u.id
    where ca.auth_timestamp >= '__START__'
      and ca.auth_timestamp <= '__END__'
      and u.imsi is not null
    group by u.imsi
)
select avg(cnt), min(cnt), max(cnt) from auth_by_imsi;

#### DST60 сколько аутентификаций ДБО на один imei операций
-- DATE_FIELDS: ca.auth_timestamp
with auth_by_imei as (
    select u.imei as h, count(1) as cnt
    from client_authentication ca
    left join unique_device u on ca.unique_device_fk = u.id
    where ca.auth_timestamp >= '__START__'
      and ca.auth_timestamp <= '__END__'
      and u.imei is not null
    group by u.imei
)
select avg(cnt), min(cnt), max(cnt) from auth_by_imei;

#### DST70 сколько аутентификаций ДБО на один IFV операций
-- DATE_FIELDS: ca.auth_timestamp
with auth_by_vendor_id as (
    select u.vendor_id as h, count(1) as cnt
    from client_authentication ca
    left join unique_device u on ca.unique_device_fk = u.id
    where ca.auth_timestamp >= '__START__'
      and ca.auth_timestamp <= '__END__'
      and u.vendor_id is not null
    group by u.vendor_id
)
select avg(cnt), min(cnt), max(cnt) from auth_by_vendor_id;

#### DST80 самые частые device hash в аутентификациях ДБО
-- DATE_FIELDS: ca.auth_timestamp
select u.device_hash, count(1)
from client_authentication ca
left join unique_device u on ca.unique_device_fk = u.id
where ca.auth_timestamp >= '__START__'
  and ca.auth_timestamp <= '__END__'
group by u.device_hash
having count(1) > 10
order by count(1) desc
limit 100;

#### DST90 самые частые device imei в аутентификациях ДБО
-- DATE_FIELDS: ca.auth_timestamp
select u.imei, count(1)
from client_authentication ca
left join unique_device u on ca.unique_device_fk = u.id
where ca.auth_timestamp >= '__START__'
  and ca.auth_timestamp <= '__END__'
  and u.imei is not null
group by u.imei
having count(1) > 10
order by count(1) desc
limit 100;

#### DST100 самые частые device imsi в аутентификациях ДБО
-- DATE_FIELDS: ca.auth_timestamp
select u.imsi, count(1)
from client_authentication ca
left join unique_device u on ca.unique_device_fk = u.id
where ca.auth_timestamp >= '__START__'
  and ca.auth_timestamp <= '__END__'
  and u.imsi is not null
group by u.imsi
having count(1) > 10
order by count(1) desc
limit 100;

#### DST110 самые частые device ifv в аутентификациях ДБО
-- DATE_FIELDS: ca.auth_timestamp
select u.vendor_id, count(1)
from client_authentication ca
left join unique_device u on ca.unique_device_fk = u.id
where ca.auth_timestamp >= '__START__'
  and ca.auth_timestamp <= '__END__'
  and u.vendor_id is not null
group by u.vendor_id
having count(1) > 10
order by count(1) desc
limit 100;

#### DST120 Срабатывание правил
-- DATE_FIELDS: timestamp
select execution_type, rule_title, avg(duration_time), min(duration_time), max(duration_time), count(1)
from incident_wrap
where timestamp >= '__START__'
  and timestamp <= '__END__'
group by execution_type, rule_title;

#### DST130 самые долгие сработки правил
-- DATE_FIELDS: timestamp
select * from incident_wrap
where timestamp >= '__START__'
  and timestamp <= '__END__'
order by duration_time desc
limit 100;

#### DST140 сколько платежей ДБО на один device hash
-- DATE_FIELDS: pt.document_save_timetamp
with pay_by_hash as (
    select u.device_hash as h, count(1) as cnt
    from payment_transaction pt
    left join unique_device u on pt.unique_device_fk = u.id
    where pt.document_save_timetamp >= '__START__'
      and pt.document_save_timetamp <= '__END__'
    group by u.device_hash
)
select avg(cnt), min(cnt), max(cnt) from pay_by_hash;

#### DST150 сколько платежей ДБО на один imsi
-- DATE_FIELDS: pt.document_save_timetamp
with pay_by_imsi as (
    select u.imsi as h, count(1) as cnt
    from payment_transaction pt
    left join unique_device u on pt.unique_device_fk = u.id
    where pt.document_save_timetamp >= '__START__'
      and pt.document_save_timetamp <= '__END__'
      and u.imsi is not null
    group by u.imsi
)
select avg(cnt), min(cnt), max(cnt) from pay_by_imsi;

#### DST160 сколько платежей ДБО на один imei
-- DATE_FIELDS: pt.document_save_timetamp
with pay_by_imei as (
    select u.imei as h, count(1) as cnt
    from payment_transaction pt
    left join unique_device u on pt.unique_device_fk = u.id
    where pt.document_save_timetamp >= '__START__'
      and pt.document_save_timetamp <= '__END__'
      and u.imei is not null
    group by u.imei
)
select avg(cnt), min(cnt), max(cnt) from pay_by_imei;

#### DST170 сколько платежей ДБО на один IFV
-- DATE_FIELDS: pt.document_save_timetamp
with pay_by_vendor_id as (
    select u.vendor_id as h, count(1) as cnt
    from payment_transaction pt
    left join unique_device u on pt.unique_device_fk = u.id
    where pt.document_save_timetamp >= '__START__'
      and pt.document_save_timetamp <= '__END__'
      and u.vendor_id is not null
    group by u.vendor_id
)
select avg(cnt), min(cnt), max(cnt) from pay_by_vendor_id;

#### DST180 Распределение платежей по категориям
-- DATE_FIELDS: pt.document_save_timetamp
select category, count(1)
from payment_transaction pt
where pt.document_save_timetamp >= '__START__'
  and pt.document_save_timetamp <= '__END__'
group by category;

---

### Запросы по джобам JOB
-- #### JOB10 Какие джобы выполнялись
-- DATE_FIELDS: ije.start_time
-- select iji.job_name,
--        ije.create_time,
--        ije.start_time,
--        ije.end_time,
--        ije.status,
--        ije.exit_code,
--        (select json_agg(p)
--         from (select key_name, string_val, date_val, long_val, double_val
--               from itx_job_execution_params par
--               where par.job_execution_id = ije.job_execution_id) p)
-- from itx_job_execution ije
-- left join itx_job_instance iji on ije.job_instance_id = iji.job_instance_id
-- where ije.start_time >= '__START__'
--   and (ije.end_time <= '__END__' or ije.end_time is null);