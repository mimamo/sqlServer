USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_GetUPC]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDItemXRef_GetUPC] @InvtId varchar(30) As
Select AlternateId From ItemXRef Where InvtId = @InvtId And AltIdType = 'U'
GO
