USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_EntityAndGlobal]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDItemXRef_EntityAndGlobal] @InvtId varchar(30), @EntityId varchar(15) As
Select AltIdType, AlternateId From ItemXRef Where InvtId = @InvtId And EntityId = @EntityId
Union
Select AltIdType, AlternateId From ItemXRef Where InvtId = @InvtId And EntityId = '*' And
AltIdType Not In (Select AltIdType From ItemXRef Where InvtId = @InvtId And EntityId = @EntityId)
GO
