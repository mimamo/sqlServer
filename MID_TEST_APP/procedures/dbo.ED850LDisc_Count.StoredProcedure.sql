USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDisc_Count]    Script Date: 12/21/2015 15:49:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850LDisc_Count] @CpnyId varchar(10), @EDIPOID varchar(10), @LineID smallint
As
	Select Count(*) From ED850LDisc
	Where 	CpnyId = @CpnyId AND
		EDIPOID = @EDIPOID AND
		LineID = @LineID
GO
