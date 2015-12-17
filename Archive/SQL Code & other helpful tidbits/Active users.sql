select a.* from (
select u.userid
, u.username
, emp.gl_subacct
, sub.Descr
, 'DENVER' as Company
from UserRec u 
INNER JOIN DENVERAPP.dbo.PJEMPLOY emp ON u.UserId = emp.employee 
INNER JOIN DENVERAPP.dbo.SubAcct sub ON emp.gl_subacct = sub.Sub
where RecType = 'U'
union all
select u.userid
, u.username
, emp.gl_subacct
, sub.Descr
, 'NEWYORK' as Company
from UserRec u 
INNER JOIN NEWYORKAPP.dbo.PJEMPLOY emp ON u.UserId = emp.employee 
INNER JOIN NEWYORKAPP.dbo.SubAcct sub ON emp.gl_subacct = sub.Sub
where RecType = 'U'
union all
select u.userid
, u.username
, emp.gl_subacct
, sub.Descr
, 'MIDWEST' as Company
from UserRec u 
INNER JOIN MIDWESTAPP.dbo.PJEMPLOY emp ON u.UserId = emp.employee 
INNER JOIN MIDWESTAPP.dbo.SubAcct sub ON emp.gl_subacct = sub.Sub
where RecType = 'U'
union all
select u.userid
, u.username
, emp.gl_subacct
, sub.Descr
, 'STREETSOURCE' as Company
from UserRec u 
INNER JOIN STREETSOURCEAPP.dbo.PJEMPLOY emp ON u.UserId = emp.employee 
INNER JOIN STREETSOURCEAPP.dbo.SubAcct sub ON emp.gl_subacct = sub.Sub
where RecType = 'U'  
) a
order by a.Company, a.UserId

select u.userid
, u.username
from UserRec u 
where RecType = 'U' order by userid


