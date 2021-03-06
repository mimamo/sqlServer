USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjutlgol_srviemp]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjutlgol_srviemp] @parm1 varchar (1), @parm2 varchar (10) , @parm3 varchar (6) , @parm4 varchar (6)    as
select empcode, min(empname),
/* revenue goal */	round(sum(round(pjutlgol.revgoal,2)),2),
/* hours goal */		round(sum(round(pjutlgol.hrs,2)),2),
/* rate goal */		'Rate Goal' = case when round(sum(round(pjutlgol.hrs,2)),2) = 0 then 0
				else round(round(sum(round(pjutlgol.revgoal,2)),2)/round(sum(round(pjutlgol.hrs,2)),2),2) end,
/* actual revenue  */	round(round(sum(round(pjutlgol.revenue,2)),2) + round(sum(round(pjutlgol.adjustments,2)),2),2),
/* actual hours */	round(sum(round(pjutlgol.units,2)),2),
/* actual rate */		'Actual Rate' = case when round(sum(round(pjutlgol.units,2)),2) = 0 then 0
 				else round(round(round(sum(round(pjutlgol.revenue,2)),2) + round(sum(round(pjutlgol.adjustments,2)),2),2)/round(sum(round(pjutlgol.units,2)),2),2) end,
/* revenue variance */  round(round(sum(round(pjutlgol.revenue,2)),2) + round(sum(round(pjutlgol.adjustments,2)),2) - round(sum(round(pjutlgol.revgoal,2)),2),2),
/* volume variance */	'Volume Variance' = case when round(sum(round(pjutlgol.hrs,2)),2) = 0 then 0
				else round(round(round(sum(round(pjutlgol.units,2)),2) - round(sum(round(pjutlgol.hrs,2)),2),2) * round(round(sum(round(pjutlgol.revgoal,2)),2)/round(sum(round(pjutlgol.hrs,2)),2), 2),2) end,
/* hours variance */	round(round(sum(round(pjutlgol.units,2)),2) - round(sum(round(pjutlgol.hrs,2)),2),2) ,
/* rate variance */ 	'Rate Variance' = case when round(sum(round(pjutlgol.hrs,2)),2) = 0 then round(round(sum(round(pjutlgol.revenue,2)),2) + round(sum(round(pjutlgol.adjustments,2)),2),2)
				else round(round(round(round(sum(round(pjutlgol.revenue,2)),2) + round(sum(round(pjutlgol.adjustments,2)),2),2) - round(sum(round(pjutlgol.revgoal,2)),2),2) - (round((round(round(sum(round(pjutlgol.units,2)),2) - round(sum(round(pjutlgol.hrs,2)),2),2)) * round(round(sum(round(pjutlgol.revgoal,2)),2)/round(sum(round(pjutlgol.hrs,2)),2), 2),2)),2) end
from pjutlgol
where empcode = @parm2
	and empstatus like @parm1
	and fiscalno >= @parm3
	and fiscalno <= @parm4
group by empcode
order by empcode
GO
