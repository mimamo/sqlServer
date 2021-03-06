USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOEvent_PostPlan]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WOEvent_PostPlan]
	@WONbr		varchar(16)
AS

	-- First check in PJTran - if any txns then return rows - Cannot delete
	IF EXISTS (SELECT * FROM PJTran WHERE Project = @WONbr)
			-- There will always be at least one record in WOEvent for the WO - Proc Stage change
			SELECT * FROM WOEvent WHERE WONbr = @WONbr
	ELSE
   			SELECT * FROM WOEvent WHERE WONbr = @WONbr and BatchID <> ''
GO
