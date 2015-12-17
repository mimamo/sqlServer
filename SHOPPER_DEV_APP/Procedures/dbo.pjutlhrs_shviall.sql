USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjutlhrs_shviall]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjutlhrs_shviall] @parm1 varchar(1),@parm2 varchar (6) , @parm3 varchar (6), @parm4 varchar(10)     as
select empcode, min(empname),
/* direct hours */	round(sum(round(pjutlhrs.directhrs,2)),2),
/* direct % */	      round(round(sum(round(pjutlhrs.directhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100,
/* goal % */		round(round(sum(round(pjutlhrs.goalhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100,
/* variance % */ 		round(round(round(sum(round(pjutlhrs.directhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100 -	round(round(sum(round(pjutlhrs.goalhrs,2)),2)/round(sum(round(pjutlhrs.availhrs,2)),2),2) * 100,2),
/* indirect hours */	round(sum(round(pjutlhrs.indirecthrs,2)),2),
/* available hours */   round(sum(round(pjutlhrs.availhrs,2)),2),
/* total hours */       round(round(sum(round(pjutlhrs.directhrs,2)),2) + round(sum(round(pjutlhrs.indirecthrs,2)),2),2)
from pjutlhrs
where	empstatus like @parm1
	and fiscalno >= @parm2
	and fiscalno <= @parm3
	and cpnyid = @parm4
group by empcode
order by empcode
GO
