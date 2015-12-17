USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RptRuntime_Cleanup]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RptRuntime_Cleanup] @parm1 varchar ( 47), @parm2 varchar ( 21) as
       Delete rptruntime from RptRuntime where rptruntime.UserId = @parm1 And
                                    rptruntime.ComputerName like @parm2
GO
