USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[RefNbr_All]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RefNbr_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[RefNbr_All] @parm1 varchar ( 10) as
            Select * from RefNbr where RefNbr like @parm1
                    order by RefNbr DESC
GO
