USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[pjallutl]    Script Date: 12/21/2015 16:12:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[pjallutl] as
select	a.employee employee,
		a.fiscalno fiscalno,
	"directhrs" = case when b.direct="Y" then
		round(sum(round(a.units,2)),2)   else 0.00 end,
	"indirecthrs" = case when b.direct="N" then
		round(sum(round(a.units,2)),2)   else 0.00 end 
from pjutlrol a, pjuttype b
where a.utilization_type = b.utilization_type
group by a.employee, a.fiscalno, b.direct
GO
