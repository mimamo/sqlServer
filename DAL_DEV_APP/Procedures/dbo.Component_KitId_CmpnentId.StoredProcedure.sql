USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_KitId_CmpnentId]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Component_KitId_CmpnentId    Script Date: 4/17/98 10:58:16 AM ******/
/****** Object:  Stored Procedure dbo.Component_KitId_CmpnentId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[Component_KitId_CmpnentId] @parm1 varchar ( 30), @parm2 varchar ( 30) as
            Select * from Component where KitId = @parm1
                           and CmpnentId like @parm2
                        Order by KitId, CmpnentId
GO
