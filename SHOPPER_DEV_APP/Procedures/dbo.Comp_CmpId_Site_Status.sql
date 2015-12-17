USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_CmpId_Site_Status]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_CmpId_Site_Status] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1) as
            Select * from Component where CmpnentId = @parm1 And siteid = @parm2 and
                status = @parm3
                order by CmpnentId, siteid, status

--UGK  086992
GO
