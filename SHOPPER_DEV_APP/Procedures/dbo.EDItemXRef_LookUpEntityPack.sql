USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_LookUpEntityPack]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDItemXRef_LookUpEntityPack] @AltIdType varchar(1), @AlternateId varchar(30), @EntityId varchar(15), @Pack int As
Select A.InvtId From ItemXRef A Inner Join Inventory B On A.InvtId = B.InvtId Inner Join
InventoryADG C On A.InvtId = C.InvtId Where A.AltIdType = @AltIdType And
A.AlternateId = @AlternateId And A.EntityId = @EntityId And B.TranStatusCode = 'AC' And (C.Pack *
C.PackSize) = @Pack
GO
