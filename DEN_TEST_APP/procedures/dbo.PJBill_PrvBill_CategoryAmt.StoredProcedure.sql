USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBill_PrvBill_CategoryAmt]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PJBill_PrvBill_CategoryAmt] 
@parm1 varchar(16),
@parm2 varchar (15)
AS
	select sum(act_amount) from PJPTDRol where Project = @parm1 and Acct = @parm2
GO
