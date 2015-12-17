USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PO_Cpny_VendId_Status]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PO_Cpny_VendId_Status    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[PO_Cpny_VendId_Status] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar(1) As
        Select * from PurchOrd where
	CpnyID Like @parm1 And
	VendID = @parm2  And
	Status = @parm3

        Order by VendId, PONbr
GO
