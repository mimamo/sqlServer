USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_Sbubrm]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_Sbubrm] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (32) , @parm4 varchar (16)  as
SELECT  *    from PJREVCAT, PJACCT
WHERE       pjrevcat.project = @parm1 and
pjrevcat.revid = @parm2 and
pjrevcat.pjt_entity = @parm3 and
pjrevcat.acct LIKE @parm4 and
pjrevcat.acct = PJACCT.acct
ORDER BY pjacct.sort_num
GO
