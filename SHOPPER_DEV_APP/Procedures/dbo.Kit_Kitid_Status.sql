USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid_Status]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_Kitid_Status] @parm1 varchar ( 30), @parm2 varchar ( 1) as
            Select * from Kit where KitId = @parm1 and status = @parm2
                order by KitId
GO
