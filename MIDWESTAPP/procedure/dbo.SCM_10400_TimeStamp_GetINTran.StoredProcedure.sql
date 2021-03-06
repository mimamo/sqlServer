USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_TimeStamp_GetINTran]    Script Date: 12/21/2015 15:55:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10400_TimeStamp_GetINTran]
	@RecordID	Integer,
	@TStamp1	Integer,
	@TStamp2	Integer
As
	SELECT *
	FROM INTran
	WHERE RecordID = @RecordID
	AND CONVERT(INT,SUBSTRING(TStamp,1,4)) = @TStamp1
	AND CONVERT(INT,SUBSTRING(TStamp,5,4)) = @TStamp2
GO
