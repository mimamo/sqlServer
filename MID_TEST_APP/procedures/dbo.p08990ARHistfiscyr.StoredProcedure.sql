USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990ARHistfiscyr]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[p08990ARHistfiscyr] As

SELECT min(fiscyr) FROM ARHIST
GO
