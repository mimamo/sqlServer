USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_KitId]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Component_KitId] @parm1 varchar ( 30) as
            Select * from Component where KitId = @parm1
           Order by KitId, CmpnentId
GO
