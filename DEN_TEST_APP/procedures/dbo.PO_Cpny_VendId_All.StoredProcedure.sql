USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PO_Cpny_VendId_All]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PO_Cpny_VendId_All    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[PO_Cpny_VendId_All] @parm1 varchar ( 10), @parm2 varchar ( 15) As
        Select * from PurchOrd where
	CpnyID Like @parm1 And
	VendID = @parm2

        Order by VendId, PONbr
GO
