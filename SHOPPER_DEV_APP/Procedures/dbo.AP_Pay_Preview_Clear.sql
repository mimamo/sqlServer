USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AP_Pay_Preview_Clear]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AP_Pay_Preview_Clear]
	@parm1 char(21)
AS
	set nocount on
	Delete from APCheck
		WHERE S4Future02 = @parm1  and status = 'X' and batnbr < '0'

	Delete from APCheckDet
		WHERE S4Future02 = @parm1 and batnbr < '0'
GO
