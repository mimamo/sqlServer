USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_GetGlobal]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDItemXRef_GetGlobal] @InvtId varchar(30), @AltIdType varchar(1) As
Select AlternateId From ItemXRef Where InvtId = @InvtId And AltIdType = @AltIdType And EntityId = '*'
GO
