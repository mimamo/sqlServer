USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgTran_Kitid_RtgSiteId]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgTran_Kitid_RtgSiteId] @parm1 varchar ( 30), @parm2 varchar (10)  as
       Select * from RtgTran where KitId = @parm1
	     and RtgSiteId = @parm2
		 order by KitId, RtgSiteId
GO
