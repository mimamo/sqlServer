USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_OrigScrnNbr_NotRlsed]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_OrigScrnNbr_NotRlsed    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_OrigScrnNbr_NotRlsed] @parm1 varchar ( 5), @parm2 varchar ( 10) as
       Select * from Batch
           where OrigScrnNbr    =  @parm1
             and Rlsed         =  0
             and BatNbr      LIKE  @parm2
           order by OrigScrnNbr, BatNbr
GO
