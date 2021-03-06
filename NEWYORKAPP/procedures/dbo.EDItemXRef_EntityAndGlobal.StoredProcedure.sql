USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_EntityAndGlobal]    Script Date: 12/21/2015 16:01:00 ******/
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
