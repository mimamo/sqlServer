USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Reprint_Bat_AR_Cpnyid]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Reprint_Bat_AR_Cpnyid    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Reprint_Bat_AR_Cpnyid] @parm1 varchar ( 10) as
       Select * from Batch
           where Module  = "AR"
             and Rlsed =  1
             and cpnyid = @parm1
           order by BatNbr
GO
