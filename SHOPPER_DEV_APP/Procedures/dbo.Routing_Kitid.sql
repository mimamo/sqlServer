USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Routing_Kitid]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--11250,11500,11510,11520,11530
	Create Proc [dbo].[Routing_Kitid] @parm1 varchar ( 30) as
            Select * from Routing where KitId like @parm1
                order by KitId
GO
