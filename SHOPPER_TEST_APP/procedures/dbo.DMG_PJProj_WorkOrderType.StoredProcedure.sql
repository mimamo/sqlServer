USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PJProj_WorkOrderType]    Script Date: 12/21/2015 16:07:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_PJProj_WorkOrderType]
	@WONbr		varchar( 16 )
	AS
	Select		Status_20			-- WO Type - M, R, P
	From		PJProj
	Where		Project = @WONbr
GO
