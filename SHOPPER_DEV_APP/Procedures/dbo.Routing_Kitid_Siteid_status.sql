USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Routing_Kitid_Siteid_status]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Routing_Kitid_Siteid_status] @parm1 varchar ( 30),@parm2 varchar (10),@parm3 varchar(1) as
            Select * from Routing where KitId = @parm1
                and siteid = @parm2 and status = @parm3
                order by KitId, siteid, status
GO
