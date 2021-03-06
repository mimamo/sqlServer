USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xqcaa]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqcaa] 
as 
select rp.ri_id, projectid, project_desc, trandate, cramt, dramt, gltran.crtd_prog, trandesc, refnbr, 
customer.name customer_name, 
case when cramt <> 0 then 
	case when datediff(day, trandate, reportdate) < 30 then cramt else 0 end 
else 
	case when datediff(day, trandate, reportdate) < 30 then -1 * dramt else 0 end 
end crrnt, 
case when cramt <> 0 then 
	case when datediff(day, trandate, reportdate) between 30 and 59 then cramt else 0 end 
else 
	case when datediff(day, trandate, reportdate) between 30 and 59 then -1 * dramt else 0 end 
end thrity_to_59, 
case when cramt <> 0 then 
	case when datediff(day, trandate, reportdate) between 60 and 89 then cramt else 0 end 
else 
	case when datediff(day, trandate, reportdate) between 60 and 89 then -1 * dramt else 0 end 
end sixty_to_89,  
case when cramt <> 0 then 
	case when datediff(day, trandate, reportdate) between 90 and 119 then cramt else 0 end 
else 
	case when datediff(day, trandate, reportdate) between 90 and 119 then -1 * dramt else 0 end 
end ninety_to_119, 
case when cramt <> 0 then 
	case when datediff(day, trandate, reportdate) between 120 and 179 then cramt else 0 end 
else 
	case when datediff(day, trandate, reportdate) between 120 and 179 then -1 * dramt else 0 end 
end one_twenty_to_179, 
case when cramt <> 0 then 
	case when datediff(day, trandate, reportdate) >= 180 then cramt else 0 end 
else 
	case when datediff(day, trandate, reportdate) >= 180 then -1 * dramt else 0 end 
end one_eighty_and_higher 
from rptruntime rp 
cross join gltran 
left outer join pjproj on projectid = project 
left outer join customer on pjproj.customer = custid 
--where trandate <= reportdate 
where gltran.perpost <= begpernbr 
and gltran.acct = '2105' 
and posted = 'P'
GO
