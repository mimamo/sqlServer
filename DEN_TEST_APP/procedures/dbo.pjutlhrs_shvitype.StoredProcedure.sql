USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjutlhrs_shvitype]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjutlhrs_shvitype] @parm1 varchar (1), @parm2 varchar (4) , @parm3 varchar (6) , @parm4 varchar (6)    as
select empcode, min(empname),
/* direct hours */	round(sum(round(pjutlhrs.directhrs,2)),2),
/* direct % */	      round(round(sum(round(pjutlhrs.directhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100,
/* goal % */		round(round(sum(round(pjutlhrs.goalhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100,
/* variance % */ 		round(round(round(sum(round(pjutlhrs.directhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100 -	round(round(sum(round(pjutlhrs.goalhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100,2),
/* indirect hours */	round(sum(round(pjutlhrs.indirecthrs,2)),2),
/* available hours */   round(sum(round(pjutlhrs.availhrs,2)),2),
/* total hours */       round(round(sum(round(pjutlhrs.directhrs,2)),2) + round(sum(round(pjutlhrs.indirecthrs,2)),2),2)
from pjutlhrs
where emptype = @parm2
	and empstatus like @parm1
	and fiscalno >= @parm3
	and fiscalno <= @parm4
group by empcode
order by empcode
GO
