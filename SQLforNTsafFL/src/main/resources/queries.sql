-- пример запроса
#### DST180 Распределение платежей по категориям
-- DATE_FIELDS: pt.document_save_timetamp
select category, count(1)
from payment_transaction pt
where pt.document_save_timetamp >= '__START__'
  and pt.document_save_timetamp <= '__END__'
group by category;

---
