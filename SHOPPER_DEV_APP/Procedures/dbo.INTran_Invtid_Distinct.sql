USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_Invtid_Distinct]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[INTran_Invtid_Distinct] @parm1 varchar ( 30) as
	Set NoCount ON
        Select distinct InvtId,SiteId from INTran where InvtId = @parm1 group by InvtId, SiteId
GO
