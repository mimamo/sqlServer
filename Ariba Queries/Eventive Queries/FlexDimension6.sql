declare @bDate date
declare @edate date

set @bDate = '3/1/2013'
set @edate = '3/31/2013'

select 
custID as FieldId4,
REPLACE(LTRIM(RTRIM(Name)),',',' ') as FieldName4,
'' as FieldId1,
'' as FieldName1,
'' as FieldId2,
'' as FieldName2,
'' as FieldId3,
'' as FieldName3
from customer 
-- Change the date each month
where Crtd_DateTime between @bDate and @edate
