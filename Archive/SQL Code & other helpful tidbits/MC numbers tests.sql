---- the right number
select 
 a.BusinessUnit 
, a.Department
, a.SalesMarketing
, a.CurMonth
, IsNull(a.CurHours,0) as 'Actual'
, IsNull(f.fPpl,0) as 'Forecast'
from 
(select BusinessUnit, Department, SalesMarketing, CurMonth
, CAST((SUM(CurHours)/166.67) as decimal(4,2)) as CurHours
from xwrk_MC_Data group by BusinessUnit, Department, SalesMarketing, curMonth)a 
LEFT OUTER JOIN 
(select BusinessUnit, Department
, CAST((SUM(fPpl)) as decimal(4,2)) as fPpl
from xwrk_MC_Forecast group by BusinessUnit, Department)f 
ON (a.BusinessUnit = f.BusinessUnit
AND a.Department = f.Department)
WHERE a.BusinessUnit NOT LIKE ('OOS%')
AND a.CurMonth = 3
and a.BusinessUnit = 'Blue Moon'
ORDER BY a.BusinessUnit, a.Department, a.SalesMarketing


--BM not right number
SELECT t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing
, SUM(t.CurHours) as 'CurHours'
, SUM(t.YTDHours) as 'YTDHours'
FROM
(select a.Brand, a.BusinessUnit, a.Department, a.SalesMarketing, CAST((SUM(a.CurHours)/166.67) as decimal(4,2)) as 'CurHours', 0 as 'YTDHours' from xwrk_MC_Data a
	WHERE a.BusinessUnit NOT LIKE ('OOS%')
	AND a.CurMonth = 3
	GROUP BY a.Brand, a.BusinessUnit, a.Department, a.SalesMarketing, a.CurMonth
	UNION
	select y.Brand, y.BusinessUnit, y.Department, y.SalesMarketing, 0 as 'CurHours', CAST((SUM(y.CurHours)/(166.67*3)) as decimal(4,2)) as 'YTDHours' from xwrk_MC_Data y
	WHERE y.BusinessUnit NOT LIKE ('OOS%')
	AND y.CurMonth <= 3
	GROUP BY y.Brand, y.BusinessUnit, y.Department, y.SalesMarketing, y.CurMonth)t
	where t.Brand = 'Blue Moon'
	GROUP BY t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing
	ORDER BY t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing
	
--ds by brand
SELECT t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing
, CAST((SUM(t.CurHours)/166.67) as decimal(4,2)) as 'CurHours'
, CAST((SUM(t.YTDHours)/(166.67*3)) as decimal(4,2)) as 'YTDHours'
FROM
(select a.Brand, a.BusinessUnit, a.Department, a.SalesMarketing, SUM(a.CurHours) as 'CurHours', 0 as 'YTDHours' from xwrk_MC_Data a
	WHERE a.BusinessUnit NOT LIKE ('OOS%')
	AND a.CurMonth = 3
	GROUP BY a.Brand, a.BusinessUnit, a.Department, a.SalesMarketing, a.CurMonth
	UNION
	select y.Brand, y.BusinessUnit, y.Department, y.SalesMarketing, 0 as 'CurHours', SUM(y.CurHours) as 'YTDHours' from xwrk_MC_Data y
	WHERE y.BusinessUnit NOT LIKE ('OOS%')
	AND y.CurMonth <= 3
	GROUP BY y.Brand, y.BusinessUnit, y.Department, y.SalesMarketing, y.CurMonth)t
	GROUP BY t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing
	ORDER BY t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing
	
--ds by brand no batch19
SELECT t.Brand
, t.BusinessUnit
, t.Department
, t.SalesMarketing
, SUM(t.CurHours) as 'CurHours'
, SUM(t.YTDHours) as 'YTDHours'
FROM
(select a.Brand, a.BusinessUnit, a.Department, a.SalesMarketing, CAST((SUM(a.CurHours)/166.67) as decimal(4,2)) as 'CurHours', 0 as 'YTDHours' from xwrk_MC_Data a
	WHERE a.BusinessUnit NOT LIKE ('OOS%')
	AND a.CurMonth = 3
	GROUP BY a.Brand, a.BusinessUnit, a.Department, a.SalesMarketing, a.CurMonth
	UNION
	select y.Brand, y.BusinessUnit, y.Department, y.SalesMarketing, 0 as 'CurHours', CAST((SUM(y.CurHours)/(166.67*3)) as decimal(4,2)) as 'YTDHours' from xwrk_MC_Data y
	WHERE y.BusinessUnit NOT LIKE ('OOS%')
	AND y.CurMonth <= 3
	GROUP BY y.Brand, y.BusinessUnit, y.Department, y.SalesMarketing, y.CurMonth)t
	WHERE t.Brand NOT IN ('Batch 19','Blue Moon') 
	GROUP BY t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing
	ORDER BY t.Brand, t.BusinessUnit, t.Department, t.SalesMarketing