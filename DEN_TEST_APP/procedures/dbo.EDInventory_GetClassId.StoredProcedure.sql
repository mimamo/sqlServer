USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_GetClassId]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInventory_GetClassId] @InvtId varchar(30) As
Select InvtId, ClassId From Inventory Where InvtId = @InvtId
GO
