USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJUTGOAL_SEQUAL]    Script Date: 12/21/2015 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUTGOAL_SEQUAL]  @parm1 varchar (10) , @parm2 varchar (6) as
select * from PJUTGOAL
where  PJUTGOAL.employee = @parm1
and    PJUTGOAL.fiscalno  = @parm2
GO
