USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_TimeStamp_GetTimeStamp]    Script Date: 12/21/2015 16:07:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_10400_TimeStamp_GetTimeStamp]
	@RecordID	Integer
As
	SELECT
	CONVERT(INT,SUBSTRING(TStamp,1,4)),
	CONVERT(INT,SUBSTRING(TStamp,5,4))
	FROM INTran (NOLOCK)
	WHERE RecordID = @RecordID
GO
