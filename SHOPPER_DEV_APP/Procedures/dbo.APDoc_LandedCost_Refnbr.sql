USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_LandedCost_Refnbr]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APDoc_LandedCost_Refnbr]
	@parmRefNbr varchar ( 10)
As
Select * from APDoc Where
	APDoc.RefNbr = @parmRefNbr and
	APDOC.DocType = 'VO'
Order by
	APDoc.RefNbr
GO
