USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_Spjrev]    Script Date: 12/21/2015 14:17:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_Spjrev] @parm1 varchar (16) , @parm2 varchar (4)  as
SELECT  *    from PJREVCAT, PJACCT, PJREVTSK
WHERE       pjrevcat.project = @parm1 and
pjrevcat.revid = @parm2 and
	    pjrevcat.acct = pjacct.acct	and
(PJACCT.acct_type = 'RV' or
	     PJACCT.acct_type = 'EX') and
pjrevcat.project = pjrevtsk.project and
pjrevcat.pjt_entity = pjrevtsk.pjt_entity and
pjrevcat.revid = pjrevtsk.revid
	ORDER BY  	pjrevcat.project,
		pjrevcat.revid,
		pjrevcat.pjt_entity,
		pjacct.sort_num,
		pjrevcat.acct
GO
