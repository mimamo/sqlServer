USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sIK1]    Script Date: 12/21/2015 16:07:13 ******/
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
