USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Update_Location_OnHand]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Update_Location_OnHand] @parm1 varchar ( 30), @parm2 varchar ( 10) as
	Set NoCount ON
	Update Location Set QtyOnHand = 0 where
                Invtid = @parm1 and SiteId = @parm2
GO
