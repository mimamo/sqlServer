USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTGOAL_SPKFISCAL]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTGOAL_SPKFISCAL]  @parm1 varchar (10) , @parm2 varchar (6) as
select * from PJUTGOAL, PJUTPER
where  PJUTGOAL.employee = @parm1
and    PJUTGOAL.fiscalno  LIKE @parm2
and PJUTGOAL.fiscalno = PJUTPER.period
order by PJUTGOAL.fiscalno
GO
