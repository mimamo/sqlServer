USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_GetUPC]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDItemXRef_GetUPC] @InvtId varchar(30) As
Select AlternateId From ItemXRef Where InvtId = @InvtId And AltIdType = 'U'
GO
