USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sPK1]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJLABDIS_sPK1]  @parm1 varchar (10) , @parm2 varchar (4) , @parm3 smallint , @parm4 varchar (2)   as
select * from PJLABDIS
where docnbr = @parm1 and
	hrs_type = @parm2 and
	linenbr = @parm3 and
	status_2 = @parm4
Order by
docnbr, hrs_type, linenbr, status_2
GO
