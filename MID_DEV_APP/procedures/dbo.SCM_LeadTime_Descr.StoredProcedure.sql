USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_LeadTime_Descr]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_LeadTime_Descr]
	@LeadTimeID	VarChar(10)
As
	Select	Descr
		From	IRLTHeader (NoLock)
		Where	LeadTimeID = @LeadTimeID
GO
