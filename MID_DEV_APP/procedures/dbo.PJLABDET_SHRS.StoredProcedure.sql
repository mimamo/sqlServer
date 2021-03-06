USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_SHRS]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_SHRS]  @parm1 varchar (10)   as
select
sum(pjlabdet.day1_hr1),
sum(pjlabdet.day2_hr1),
sum(pjlabdet.day3_hr1),
sum(pjlabdet.day4_hr1),
sum(pjlabdet.day5_hr1),
sum(pjlabdet.day6_hr1),
sum(pjlabdet.day7_hr1),
sum(pjlabdet.day1_hr2),
sum(pjlabdet.day2_hr2),
sum(pjlabdet.day3_hr2),
sum(pjlabdet.day4_hr2),
sum(pjlabdet.day5_hr2),
sum(pjlabdet.day6_hr2),
sum(pjlabdet.day7_hr2),
sum(pjlabdet.day1_hr3),
sum(pjlabdet.day2_hr3),
sum(pjlabdet.day3_hr3),
sum(pjlabdet.day4_hr3),
sum(pjlabdet.day5_hr3),
sum(pjlabdet.day6_hr3),
sum(pjlabdet.day7_hr3),
	sum(pjlabdet.total_amount)
FROM  pjlabdet
where    docnbr     =  @parm1
GO
