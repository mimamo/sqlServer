USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xUpdate_EstRevInq_RevisionID]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xUpdate_EstRevInq_RevisionID] 
@parm1 varchar(1),
@parm2 varchar(16),  --Project
@parm3 Varchar(4),   --Revision
@parm4 Varchar(4)   --Revision
as

Update xEstRevInq set PrevEst = 0, RevAmt = 0, RevisedEst = 0 where xEstRevInq.Project = @parm1

If @parm1 = 'A' --Amount
Begin


	--Only the project is passed in Revision ID has no barring 
	update xEstRevInq set xEstRevInq.PrevEst = vt_Altara_kc_UNPostedPrevEst.Amount
	from vt_Altara_kc_UNPostedPrevEst
	where
	    vt_Altara_kc_UNPostedPrevEst.Project = @parm2 --Get all records for this project
	and vt_Altara_kc_UNPostedPrevEst.RevID = @parm4
	and xEstRevInq.Project = vt_Altara_kc_UNPostedPrevEst.Project  -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_UNPostedPrevEst.pjt_entity

	
	update xEstRevInq set xEstRevInq.RevisedEst = vt_Altara_kc_UNPostedRevEst.Amount
	from vt_Altara_kc_UNPostedRevEst
	where
	    vt_Altara_kc_UNPostedRevEst.Project = @parm2  --Get all records for this project and Revision ID
	and vt_Altara_kc_UNPostedRevEst.RevID = @parm3
	and xEstRevInq.Project = vt_Altara_kc_UNPostedRevEst.Project -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_UNPostedRevEst.pjt_entity 
	--Paramters past in PJREVHDR.project and PJREVHDR.revid = Revision ID entered.  


End
Else
Begin  --Unit

	update xEstRevInq set xEstRevInq.PrevEst = vt_Altara_kc_UNPostedPrevEst.Units
	from vt_Altara_kc_UNPostedPrevEst
	where
	    vt_Altara_kc_UNPostedPrevEst.Project = @parm2 --Get all records for this project
	--???? and vt_Altara_kc_UNPostedPrevEst.RevID = @parm3
	and xEstRevInq.Project = vt_Altara_kc_UNPostedPrevEst.Project -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_UNPostedPrevEst.pjt_entity 
	-- Revision ID has no barring 

	update xEstRevInq set xEstRevInq.RevisedEst = vt_Altara_kc_UNPostedRevEst.Units
	from vt_Altara_kc_UNPostedRevEst
	where
	    vt_Altara_kc_UNPostedRevEst.Project = @parm2  --Get all records for this project and Revision ID
	and vt_Altara_kc_UNPostedRevEst.RevID = @parm3
	and xEstRevInq.Project = vt_Altara_kc_UNPostedRevEst.Project -- Join it with the Projct and task combination
	and xEstRevInq.pjt_entity = vt_Altara_kc_UNPostedRevEst.pjt_entity 
	--Paramters past in PJREVHDR.project and PJREVHDR.revid = Revision ID entered.  

End
update xEstRevInq set RevAmt = RevisedEst - PrevEst
GO
