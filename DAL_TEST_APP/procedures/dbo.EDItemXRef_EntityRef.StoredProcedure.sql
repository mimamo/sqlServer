USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_EntityRef]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDItemXRef_EntityRef] @InvtId varchar(30), @AltIdType varchar(1), @EntityId varchar(15) As
Select AlternateId From ItemXRef Where InvtId = @InvtId And AltIdType = @AltIdType And EntityId = @EntityId
GO
