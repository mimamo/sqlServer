USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_LotSerTrack]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDInventory_LotSerTrack] @InvtId varchar(30) As
Select LotSerTrack, SerAssign, StkUnit, ClassId From Inventory Where InvtId = @InvtId
GO
