USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBill_Est_CategoryAmt]    Script Date: 12/21/2015 15:55:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PJBill_Est_CategoryAmt] 
@parm1 varchar(16),
@parm2 varchar (15)
AS
	select sum(eac_amount) from PJPTDRol where Project = @parm1 and Acct = @parm2
GO
