USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventory_LotSerialTrack]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDInventory_LotSerialTrack] @InvtId varchar(30) As
Select LotSerTrack, SerAssign From Inventory Where InvtId = @InvtId
GO
