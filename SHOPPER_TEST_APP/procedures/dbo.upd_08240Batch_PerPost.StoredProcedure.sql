USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[upd_08240Batch_PerPost]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.upd_08240Batch_PerPost    Script Date: 11/29/00 12:30:33 PM ******/
CREATE PROC [dbo].[upd_08240Batch_PerPost] @parm1 varchar(10), @parm2 VarChar (6) AS
UPDATE Batch
  SET PerPost = @parm2
 WHERE Batnbr = @parm1 AND
       Module = 'AR'
GO
