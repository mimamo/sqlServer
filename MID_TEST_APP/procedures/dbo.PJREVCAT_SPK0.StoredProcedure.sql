USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_SPK0]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_SPK0] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (32) , @parm4 varchar (16)  as
SELECT  *    from PJREVCAT
WHERE       pjrevcat.project = @parm1 and
pjrevcat.revid = @parm2 and
pjrevcat.pjt_entity = @parm3 and
pjrevcat.acct = @parm4
	ORDER BY  	pjrevcat.project,
		pjrevcat.revid,
		pjrevcat.pjt_entity,
		pjrevcat.acct
GO
