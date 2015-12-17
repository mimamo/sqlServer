USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventoryADG_StdCtnInfo]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDInventoryADG_StdCtnInfo] @InvtId varchar(30) As
Select InvtId, PackMethod, Pack, PackSize, Cast(PackUOM As char(6)) From InventoryADG Where InvtId = @InvtId
GO
