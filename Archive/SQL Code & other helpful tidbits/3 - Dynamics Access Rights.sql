-- Report to get all of the access rights by user
select ar.CompanyID as 'Company'
, ar.UserId as 'Group'
, usr.UserId
, usr.UserName
, adr.ScreenNumber
, s.Name as 'Screen Name'
, CASE WHEN adr.ViewRights = '0' THEN 'No' ELSE 'YES' END as 'View Rights'
, CASE WHEN adr.InsertRights = '0' THEN 'No' ELSE 'YES' END as 'Insert Rights'
, CASE WHEN adr.UpdateRights = '0' THEN 'No' ELSE 'YES' END as 'Update Rights'
, CASE WHEN adr.DeleteRights = '0' THEN 'No' ELSE 'YES' END as 'Delete Rights'
, CASE WHEN adr.InitRights = '0' THEN 'No' ELSE 'YES' END as 'Initialization Mode Rights'
from DENVERSYS.dbo.AccessRights ar 
LEFT OUTER JOIN DENVERSYS.dbo.AccessDetRights adr ON ar.UserId = adr.UserId
LEFT OUTER JOIN DENVERSYS.dbo.screen s ON adr.ScreenNumber = s.Number 
LEFT OUTER JOIN (select g.GroupId, u.UserId, u.UserName from DENVERSYS.dbo.UserGrp g 
LEFT OUTER JOIN DENVERSYS.dbo.Userrec u ON g.UserId = u.UserId
where u.RecType = 'U') usr ON ar.UserId = usr.GroupId
-- Filter by Company (Denver or All or everything if removed)
	where ar.CompanyID <> '' 
-- Filter by Type of Rights Group (G) or User (U)
	AND ar.RecType = 'G'
-- Filter by UserID
--AND usr.UserId IN ('jsmith')
-- Filter By Group Name
--AND ar.UserId like 'PAYROLL REPORTING'
-- Filter By Screen Number
--AND adr.ScreenNumber = 'PAPRJ00'
order by ar.CompanyID, ar.UserId, usr.UserId, usr.UserName


-- Get just groups and screens
-- Report to get all of the access rights by user
select ar.CompanyID as 'Company'
, ar.UserId as 'Group'
--, usr.UserId
--, usr.UserName
, adr.ScreenNumber
, s.Name as 'Screen Name'
, CASE WHEN adr.ViewRights = '0' THEN 'No' ELSE 'YES' END as 'View Rights'
, CASE WHEN adr.InsertRights = '0' THEN 'No' ELSE 'YES' END as 'Insert Rights'
, CASE WHEN adr.UpdateRights = '0' THEN 'No' ELSE 'YES' END as 'Update Rights'
, CASE WHEN adr.DeleteRights = '0' THEN 'No' ELSE 'YES' END as 'Delete Rights'
, CASE WHEN adr.InitRights = '0' THEN 'No' ELSE 'YES' END as 'Initialization Mode Rights'
from DENVERSYS.dbo.AccessRights ar 
LEFT OUTER JOIN DENVERSYS.dbo.AccessDetRights adr ON ar.UserId = adr.UserId
LEFT OUTER JOIN DENVERSYS.dbo.screen s ON adr.ScreenNumber = s.Number 
LEFT OUTER JOIN (select g.GroupId, u.UserId, u.UserName from DENVERSYS.dbo.UserGrp g 
LEFT OUTER JOIN DENVERSYS.dbo.Userrec u ON g.UserId = u.UserId
where u.RecType = 'U') usr ON ar.UserId = usr.GroupId
-- Filter by Company (Denver or All or everything if removed)
	where ar.CompanyID <> '' 
-- Filter by Type of Rights Group (G) or User (U)
	AND ar.RecType = 'G'
-- Filter by UserID
--AND usr.UserId IN ('jsmith')
-- Filter By Group Name
--AND ar.UserId like 'PAYROLL REPORTING'
-- Filter By Screen Number
--AND adr.ScreenNumber = 'PAPRJ00'
group by ar.CompanyID, ar.UserId, adr.ScreenNumber, s.Name, adr.ViewRights, adr.InsertRights, adr.UpdateRights, adr.DeleteRights, adr.InitRights
order by ar.CompanyID, ar.UserId--, usr.UserId, usr.UserName

-- compare groups
select adr.ScreenNumber
, s.Name as 'Screen Name' 
, ar.UserId as 'Group'
from DENVERSYS.dbo.AccessRights ar 
LEFT OUTER JOIN DENVERSYS.dbo.AccessDetRights adr ON ar.UserId = adr.UserId
LEFT OUTER JOIN DENVERSYS.dbo.screen s ON adr.ScreenNumber = s.Number 
where  ar.UserId LIKE 'ACCOUNTING%'
GROUP BY adr.ScreenNumber, ar.UserId, s.Name
order by  adr.ScreenNumber, ar.UserId


--- get users in groups
-- Report to get all of the access rights by user
select ar.CompanyID
, ar.UserId as 'Group'
, usr.UserId
, usr.UserName
from DENVERSYS.dbo.AccessRights ar 
LEFT OUTER JOIN (select g.GroupId, u.UserId, u.UserName from DENVERSYS.dbo.UserGrp g 
LEFT OUTER JOIN DENVERSYS.dbo.Userrec u ON g.UserId = u.UserId
where u.RecType = 'U') usr ON ar.UserId = usr.GroupId
-- Filter by Company (Denver or All or everything if removed)
	where ar.CompanyID <> '' 
-- Filter by Type of Rights Group (G) or User (U)
	AND ar.RecType = 'G'
-- Filter by UserID
--AND usr.UserId IN ('jsmith')
-- Filter By Group Name
--AND ar.UserId like 'PAYROLL REPORTING'
-- Filter By Screen Number
--AND adr.ScreenNumber = 'PAPRJ00'
and usr.UserId is not null
order by ar.CompanyID, ar.UserId, usr.UserId, usr.UserName

