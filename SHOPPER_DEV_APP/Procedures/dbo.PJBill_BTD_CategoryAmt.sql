USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBill_BTD_CategoryAmt]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PJBill_BTD_CategoryAmt] 
@parm1 varchar(16),
@parm2 varchar (15)
AS
	select sum(act_amount) from PJPTDRol where Project = @parm1 and Acct = @parm2
GO
