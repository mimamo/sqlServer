USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sIK1]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJLABDIS_sIK1] @parm1 varchar (6), @parm2 varchar (10)    as
select * from PJLABDIS
where
fiscalno = @parm1 and
CpnyId_home = @parm2 and
status_gl = 'U'
Order by employee
GO
