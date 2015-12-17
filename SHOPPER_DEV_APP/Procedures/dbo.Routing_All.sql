USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Routing_All]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Routing_All] @parm1 varchar ( 30),@parm2 varchar (1), @parm3 varchar (10)  as
            Select * from Routing where KitId like @parm1 and Status like @parm2 and SiteID like @parm3
                order by KitId, SiteID, Status
GO
