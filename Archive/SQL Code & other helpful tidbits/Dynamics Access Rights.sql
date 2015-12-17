-- Report to get all of the access rights by user
-- ar.UserID is the Group name
--usr.UserID is the User name for People
select ar.UserId as 'Group'
, usr.UserId
, usr.UserName
, adr.ScreenNumber
, s.Name as 'Screen Name'
, CASE WHEN adr.ViewRights = '0' THEN 'No' ELSE 'YES' END as 'View Rights'
, CASE WHEN adr.InsertRights = '0' THEN 'No' ELSE 'YES' END as 'Insert Rights'
, CASE WHEN adr.UpdateRights = '0' THEN 'No' ELSE 'YES' END as 'Update Rights'
, CASE WHEN adr.DeleteRights = '0' THEN 'No' ELSE 'YES' END as 'Delete Rights'
from DENVERSYS.dbo.AccessRights ar 
LEFT OUTER JOIN DENVERSYS.dbo.AccessDetRights adr ON ar.UserId = adr.UserId
LEFT OUTER JOIN DENVERSYS.dbo.screen s ON adr.ScreenNumber = s.Number 
LEFT OUTER JOIN (select g.GroupId, u.UserId, u.UserName from DENVERSYS.dbo.UserGrp g 
LEFT OUTER JOIN DENVERSYS.dbo.Userrec u ON g.UserId = u.UserId
where u.RecType = 'U') usr ON ar.UserId = usr.GroupId
where ar.CompanyID = 'DENVER' AND ar.RecType = 'G'
AND usr.UserId like 'dbertram'
order by ar.UserId, usr.UserId, usr.UserName



