USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_RefNbr_KitId_LineNbr_Inventory]    Script Date: 12/21/2015 13:56:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BOMTran_RefNbr_KitId_LineNbr_Inventory] @parm1 varchar ( 15), @KitId varchar(30), @SiteId varchar (10), @parm2beg smallint, @parm2end smallint as
   	Select * from BOMTran, Inventory where
		BOMTran.RefNbr = @parm1 and
		BOMTran.KitId = @KitId and
		BOMTran.SiteId = @SiteId and
		BOMTran.BOMLineNbr between @parm2beg and @parm2end and
		Inventory.InvtId = BOMTran.CmpnentId
		order by BOMTran.RefNbr, BOMTran.BOMLineNbr
GO
