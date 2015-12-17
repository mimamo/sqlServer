USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IR_InvVendPref_All]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IR_InvVendPref_All] @InvtID VarChar(30), @VendId varchar(15) as
	Select * from IR_InvVendPref where InvtId = @InvtId and VendId Like @VendId order by InvtId, VendID
GO
