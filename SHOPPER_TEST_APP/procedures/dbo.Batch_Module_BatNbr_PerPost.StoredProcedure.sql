USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Module_BatNbr_PerPost]    Script Date: 12/21/2015 16:06:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Batch_Module_BatNbr_PerPost] @parm1 varchar ( 2), @parm2 varchar ( 10), @parm3 varchar (6) as
       Select * from Batch
           where Module  = @parm1
             and BatNbr  = @parm2
             and PerPost = @parm3
GO
