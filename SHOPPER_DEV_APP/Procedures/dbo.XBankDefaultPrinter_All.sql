USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XBankDefaultPrinter_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[XBankDefaultPrinter_All]
		@CpnyID varchar(10),
		@Acct varchar(10),
		@SubAcct Varchar(24),
		@ComputerName varchar(25)
AS

Select * from XBDfltPrinter
Where
	CpnyID = @CpnyID and
	Acct = @Acct and
	Subacct = @SubAcct and
	ComputerName = @ComputerName
Order By
	CpnyID,
	Acct,
	SubAcct,
	ComputerName
GO
