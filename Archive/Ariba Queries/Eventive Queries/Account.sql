select 
LTRIM(RTRIM(acct)) as AccountID,
'' as CompanyCode,
REPLACE(LTRIM(RTRIM(Descr)),',',' ') as AccountName,
LTRIM(RTRIM(acct)) as MajorAccountId,
REPLACE(LTRIM(RTRIM(Descr)),',',' ') as MajorAccountName,
AcctType as ChartofAccountsID,
case when AcctType = '1A' then 'Asset'
when AcctType = '2L' then 'Liability'
when AcctType = '3I' then 'Revenue' 
when AcctType = '3E' then 'Expense' 
end as ChartofAccountsName

from Account 