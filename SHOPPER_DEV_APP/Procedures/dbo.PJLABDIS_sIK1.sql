USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDIS_sIK1]    Script Date: 12/16/2015 15:55:27 ******/
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
