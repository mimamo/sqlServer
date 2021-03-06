USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xUpdate_EstRevInq_Posted_RevID]    Script Date: 12/21/2015 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xUpdate_EstRevInq_Posted_RevID] 
@parm1 varchar(1),
@parm2 varchar(16),
@parm3 varchar(4)

as

Update xEstRevInq set PrevEst = 0, RevAmt = 0, RevisedEst = 0 where xEstRevInq.Project = @parm1

If @parm1 = 'A' --Amount
Begin

	update xEstRevInq set xEstRevInq.PrevEst = vt_Altara_kc_PostedPrevEst.Amount
	from vt_Altara_kc_PostedPrevEst
	where
	    vt_Altara_kc_PostedPrevEst.Project = @parm2 --Get all records for this project and Revision ID
	and vt_Altara_kc_PostedPrevEst.Revid = @parm3
	and xEstRevInq.Project = vt_Altara_kc_PostedPrevEst.Project -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_PostedPrevEst.pjt_entity 
	--paramter passed in will be PJREVHDR.PROJECT = Project entered by the user and PJREVHDR.REVID  =  Revision ID entered by the user

	
	update xEstRevInq set xEstRevInq.RevisedEst = vt_Altara_kc_PostedRevEst.Amount
	from vt_Altara_kc_PostedRevEst
	where
	    vt_Altara_kc_PostedRevEst.Project = @parm2 --Get all records for this project and Revision ID
	and vt_Altara_kc_PostedRevEst.Revid = @parm3
	and xEstRevInq.Project = vt_Altara_kc_PostedRevEst.Project  -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_PostedRevEst.pjt_entity	
	--Parameters:  Project and Revision ID they the user Entered

End
Else
Begin  --Unit

	update xEstRevInq set xEstRevInq.PrevEst = vt_Altara_kc_PostedPrevEst.Units
	from vt_Altara_kc_PostedPrevEst
	where
		    vt_Altara_kc_PostedPrevEst.Project = @parm2 --Get all records for this project and Revision ID
	and vt_Altara_kc_PostedPrevEst.Revid = @parm3
	and xEstRevInq.Project = vt_Altara_kc_PostedPrevEst.Project -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_PostedPrevEst.pjt_entity 
	--paramter passed in will be PJREVHDR.PROJECT = Project entered by the user and PJREVHDR.REVID  =  Revision ID entered by the user

	
	update xEstRevInq set xEstRevInq.RevisedEst = vt_Altara_kc_PostedRevEst.Units
	from vt_Altara_kc_PostedRevEst
	where
	    vt_Altara_kc_PostedRevEst.Project = @parm2 --Get all records for this project and Revision ID
	and vt_Altara_kc_PostedRevEst.Revid = @parm3
	and xEstRevInq.Project = vt_Altara_kc_PostedRevEst.Project -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_PostedRevEst.pjt_entity
	--Parameters:  Project and Revision ID they the user Entered

End
update xEstRevInq set RevAmt = RevisedEst - PrevEst
GO
