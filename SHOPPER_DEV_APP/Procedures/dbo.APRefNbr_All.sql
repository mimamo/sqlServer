USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APRefNbr_All]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APRefNbr_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Proc [dbo].[APRefNbr_All] @parm1 varchar ( 10) as
            Select * from APRefNbr where RefNbr like @parm1
                    order by RefNbr DESC
GO
