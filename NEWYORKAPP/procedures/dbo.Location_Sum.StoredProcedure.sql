USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Location_Sum]    Script Date: 12/21/2015 16:01:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Location_Sum] @parm1 varchar ( 30), @parm2 varchar ( 10) as
	Set NoCount ON
	Select Sum(QtyOnHand) from
        Location where InvtId = @parm1 and SiteId = @parm2
GO
