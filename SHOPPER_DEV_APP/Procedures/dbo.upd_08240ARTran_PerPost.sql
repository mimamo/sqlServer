USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[upd_08240ARTran_PerPost]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.upd_08240ARTran_PerPost    Script Date: 11/29/00 12:30:33 PM ******/
CREATE PROC [dbo].[upd_08240ARTran_PerPost] @parm1 varchar(10), @parm2 VarChar (6) AS
UPDATE ARTran
  SET PerPost = @parm2
 WHERE Batnbr = @parm1
GO
