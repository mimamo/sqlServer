USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_Invtid_SiteId_]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[INTran_Invtid_SiteId_] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 2) as
	Set NoCount ON
	Select * from INTran where Invtid = @parm1 and SiteId = @parm2
      		and TranType = @parm3 and rlsed = 1 order by InvtId, SiteId, TranType
GO
