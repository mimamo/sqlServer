USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_sacct]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_sacct] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (16)  as
SELECT  *    from PJREVCAT
WHERE       pjrevcat.project = @parm1 and
pjrevcat.revid = @parm2 and
pjrevcat.acct = @parm3
ORDER BY        pjrevcat.project,
pjrevcat.revid,
pjrevcat.pjt_entity,
pjrevcat.acct
GO
