USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_Invtid_SiteId_DC]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[INTran_Invtid_SiteId_DC] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 2), @parm4 varchar ( 1) as
Set NoCount ON
Select * from INTran where Invtid = @parm1 and SiteId = @parm2
      and TranType = @parm3 and DrCr = @parm4 and rlsed = 1
      order by InvtId, SiteId,  TranType
GO
