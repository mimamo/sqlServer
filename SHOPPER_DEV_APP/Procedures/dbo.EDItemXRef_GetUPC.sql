USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_GetUPC]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDItemXRef_GetUPC] @InvtId varchar(30) As
Select AlternateId From ItemXRef Where InvtId = @InvtId And AltIdType = 'U'
GO
