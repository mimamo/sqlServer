USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[IR_InvVendPref_All]    Script Date: 12/21/2015 16:01:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IR_InvVendPref_All] @InvtID VarChar(30), @VendId varchar(15) as
	Select * from IR_InvVendPref where InvtId = @InvtId and VendId Like @VendId order by InvtId, VendID
GO
