USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Insert_IN10400_Return]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_Insert_IN10400_Return]
	@BatNbr		VarChar(10),
    	@ComputerName	VarChar(21),
	@MsgNbr		SmallInt,
	@Parm00		VarChar(30),
	@Parm01		VarChar(30),
	@Parm02		VarChar(30),
	@Parm03		VarChar(30),
	@Parm04		VarChar(30),
	@Parm05		VarChar(30),
	@ParmCnt	SmallInt,
	@S4Future01	VarChar(30),
	@SQLErrorNbr	SmallInt
As
	Insert	Into IN10400_Return
		(BatNbr, ComputerName, MsgNbr, Parm00, Parm01,
		Parm02, Parm03, Parm04, Parm05, ParmCnt,
		S4Future01, SQLErrorNbr)
		Values
		(@BatNbr, @ComputerName, @MsgNbr, @Parm00, @Parm01,
		@Parm02, @Parm03, @Parm04, @Parm05, @ParmCnt,
		@S4Future01, @SQLErrorNbr)
GO
