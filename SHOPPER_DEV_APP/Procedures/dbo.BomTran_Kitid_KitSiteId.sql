USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BomTran_Kitid_KitSiteId]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BomTran_Kitid_KitSiteId] @parm1 varchar ( 30), @parm2 varchar (10)   as
       Select * from BomTran where KitId = @parm1
	     and KitSiteId = @parm2
		 order by KitId, KitSiteId
GO
