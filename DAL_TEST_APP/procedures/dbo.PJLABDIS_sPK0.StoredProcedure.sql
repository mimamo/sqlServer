USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sPK0]    Script Date: 12/21/2015 13:57:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJLABDIS_sPK0]  @parm1 varchar (10)   as
select * from PJLABDIS
where docnbr = @parm1
Order by
docnbr, hrs_type, linenbr desc
GO
