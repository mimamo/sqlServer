USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInventoryADG_StdCtnInfo]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDInventoryADG_StdCtnInfo] @InvtId varchar(30) As
Select InvtId, PackMethod, Pack, PackSize, Cast(PackUOM As char(6)) From InventoryADG Where InvtId = @InvtId
GO
