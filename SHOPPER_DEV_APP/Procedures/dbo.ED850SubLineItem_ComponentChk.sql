USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SubLineItem_ComponentChk]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850SubLineItem_ComponentChk] @KitId varchar(30), @ComponentId varchar(30)
As
	Select A.CmpnentQty, B.StkUnit, B.ClassId
	From Component A Inner Join Inventory B On A.CmpnentId = B.InvtId
	Where A.KitId = @KitId And A.CmpnentId = @ComponentId
GO
