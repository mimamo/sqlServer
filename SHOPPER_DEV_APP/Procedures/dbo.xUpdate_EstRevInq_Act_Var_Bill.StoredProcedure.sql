USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xUpdate_EstRevInq_Act_Var_Bill]    Script Date: 12/21/2015 14:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xUpdate_EstRevInq_Act_Var_Bill] 
@parm1 varchar(1),
@parm2 varchar(16)
as

-- Initialize the record,  set fields to zero
Update xEstRevInq set Actual = 0, Variance = 0, Billed = 0 where xEstRevInq.Project = @parm1

If @parm1 = 'A' --Amount
Begin
	--Actual Column
	update xEstRevInq set xEstRevInq.Actual = vt_Altara_kc_Actual.Amt_Actual
	from vt_Altara_kc_Actual
	where
	xEstRevInq.Project = vt_Altara_kc_Actual.Project and 
	xEstRevInq.pjt_entity = vt_Altara_kc_Actual.pjt_entity and
	xEstRevInq.Project = @parm2
	
	--Billed Column
	update xEstRevInq set xEstRevInq.Billed = vt_Altara_kc_Billed.AMT_Billed 
	from vt_Altara_kc_Billed
	where
	xEstRevInq.Project = vt_Altara_kc_Billed.Project and 
	xEstRevInq.pjt_entity = vt_Altara_kc_Billed.pjt_entity AND
	xEstRevInq.Project = @parm2
End
Else
Begin  --Unit
	--Actual Column
	update xEstRevInq set xEstRevInq.Actual = vt_Altara_kc_Actual.Units_Actual
	from vt_Altara_kc_Actual
	where
	xEstRevInq.Project = vt_Altara_kc_Actual.Project and 
	xEstRevInq.pjt_entity = vt_Altara_kc_Actual.pjt_entity and
	xEstRevInq.Project = @parm2
	
	--Billed Column
	update xEstRevInq set xEstRevInq.Billed = vt_Altara_kc_Billed.Units_Billed 
	from vt_Altara_kc_Billed
	where
	xEstRevInq.Project = vt_Altara_kc_Billed.Project and 
	xEstRevInq.pjt_entity = vt_Altara_kc_Billed.pjt_entity and
	xEstRevInq.Project = @parm2

End
GO
