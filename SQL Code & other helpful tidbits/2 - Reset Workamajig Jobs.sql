-- reset stuck JOBs
select * from [xTRAPS_JOBHDR] where trigger_status <> 'IM'

update [xTRAPS_JOBHDR] 
set trigger_status = '00'
where trigger_status <> 'IM'


-- Reset time JOBs
select * from xWKMJG_Log_Queue where TransferStatus = 'error' and error not like 'UK'

Select * from xWKMJG_Time_Det where LogKey = '40410'

update xWKMJG_Time_Det
set SalesAccountNumber = '12150'
where ProjectNumber IN ('04765212APS')
and TotalHours = '0.5000'
and LogKey IN ('40410')
and SalesAccountNumber = '00000'

update xWKMJG_Log_Queue 
set DateTransferred=null,Error=null,TransferStatus=null
where LogKey IN ('40410')



-- view invoice detail
--select * from xWKMJG_Inv_Det where LogKey IN ('39008','39054','39055','39056')


--- Change multiple functions at one time
Select * from xWKMJG_Time_Det where LogKey IN ('39385','39421','39422','39423','39424','39425','39489')

Select * from xWKMJG_Time_Det where ProjectNumber IN ('04871112APS','05269613APS')
--and TotalHours = '1.2500'
and LogKey IN ('39385','39421','39422','39423','39424','39425','39489')
and SalesAccountNumber = '00000'

update xWKMJG_Time_Det
set SalesAccountNumber = '12150'
where ProjectNumber IN ('04871112APS','05269613APS')
--and TotalHours = '1.2500'
and LogKey IN ('39385','39421','39422','39423','39424','39425','39489')
and SalesAccountNumber = '00000'