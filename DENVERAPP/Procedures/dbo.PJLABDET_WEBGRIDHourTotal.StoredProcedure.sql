USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_WEBGRIDHourTotal]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[PJLABDET_WEBGRIDHourTotal] @parm1 varchar (10)  as select sum(day1_hr1+day1_hr2+day1_hr3) "Day1",
sum(day2_hr1+day2_hr2+day2_hr3) "Day2",
sum(day3_hr1+day3_hr2+day3_hr3) "Day3",
sum(day4_hr1+day4_hr2+day4_hr3) "Day4",
sum(day5_hr1+day5_hr2+day5_hr3) "Day5",
sum(day6_hr1+day6_hr2+day6_hr3) "Day6",
sum(day7_hr1+day7_hr2+day7_hr3) "Day7",
sum(day1_hr2+day2_hr2+day3_hr2+day4_hr2+day5_hr2+day6_hr2+day7_hr2) "OverTime1",
sum(day1_hr3+day2_hr3+day3_hr3+day4_hr3+day5_hr3+day6_hr3+day7_hr3) "OverTime2"
from pjlabdet 
where docnbr = @parm1
GO
