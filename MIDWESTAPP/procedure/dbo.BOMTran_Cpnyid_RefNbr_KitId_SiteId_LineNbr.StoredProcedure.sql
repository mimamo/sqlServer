USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_Cpnyid_RefNbr_KitId_SiteId_LineNbr]    Script Date: 12/21/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[BOMTran_Cpnyid_RefNbr_KitId_SiteId_LineNbr] @parm1 varchar ( 10), @parm2 varchar (15),
	@parm3 varchar (30), @parm4 varchar (10), @parm5beg smallint, @parm5end smallint as
   	Select 	BOMTran.*, Inventory.Descr, Inventory.StkUnit,
 		Case When BOMTran.SubKitStatus = 'A'
			Then	1
			Else	0
			End,(BOMTran.CmpnentQty + BOMTran.AssyQty)
	from BOMTran, Inventory where
		BOMTran.Cpnyid = @parm1 and
		BOMTran.RefNbr = @parm2 and
		BOMTran.BOMLineNbr between
       		@parm5beg and @parm5end and
		BOMTran.CmpnentID = Inventory.InvtID
		order by BOMTran.Cpnyid, BOMTran.RefNbr, BOMTran.BOMLineNbr
GO
