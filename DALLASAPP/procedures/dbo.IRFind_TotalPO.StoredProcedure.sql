USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRFind_TotalPO]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRFind_TotalPO] @InvtID VarChar(30), @SiteID VarChar(10) As
	Select
		Sum	(	Case UnitMultDiv 	When 'M' Then  Round((QtyOrd - QtyRcvd) * CnvFact, 9)
							When 'D' Then  Round((QtyOrd - QtyRcvd) / CnvFact, 9)
				End
			)'QtyNeeded'
	From
		PurOrdDet
	Where
		InvtId = @InvtId
		And SiteID = @SiteID
		and exists (Select * from PurchOrd where Purchord.PoNbr = PurOrdDet.PoNbr and Purchord.Status in ('O','P','Q'))
GO
